const SHA256 = require ('crypto-js/sha256');
class Block{
    constructor(index, timestamp, data, previousHash = ''   ){
        this.index = index;
        this.timestamp = timestamp;
        this.data = data;
        this.previousHash = previousHash;
        this.hash = this.computehash();
        this.nonce = 0;
    }
    computehash(){
        return SHA256(this.index + this.previousHash + this.timestamp + JSON.stringify(this.data)+ this.nonce).toString();
    }
    Blockmining(difficulty){
        while(this.hash.substring(0, difficulty) !== Array(difficulty + 1).join("0")){
            this.nonce++;
            this.hash = this.computehash();
        }
        console.log("Block mined: " + this.hash);
    }
}
