class Block
  attr_reader :index, :timestamp, :transactions, 
							:transactions_count, :previous_hash, 
							:nonce, :hash, :creator 

  def initialize(index, timestamp, transactions, previous_hash, creator)
    @index         		 	 = index
    @timestamp      	 	 = Time.now
    @transactions 	 		 = transactions
		@transactions_count  = transactions.size
    @previous_hash 		 	 = previous_hash
    @creator             = creator
    @nonce, @hash  		 	 = compute_hash_with_proof_of_work
  end

	def compute_hash_with_proof_of_work(difficulty="00000")
		nonce = 0
		loop do 
			hash = calc_hash_with_nonce(nonce)
			if hash.start_with?(difficulty)
				return [nonce, hash]
			else
				nonce +=1
			end
		end
	end
	
  def calc_hash_with_nonce(nonce=0)
    sha = Digest::SHA256.new
    sha.update( nonce.to_s + 
								@index.to_s + 
								@timestamp.to_s + 
								@transactions.to_s + 
								@transactions_count.to_s +	
								@previous_hash )
    sha.hexdigest 
  end

  def self.first( *transactions )    # Create genesis block
    ## Uses index zero (0) and arbitrary previous_hash ("0")
      Block.new(0, Time.now, "Genesis Block", "0", "Elam")
  end

  def self.next( previous, transactions )
    Block.new( previous.index+1,Time.now, transactions, previous.hash, "Francisco" )
  end
end  # class Block
