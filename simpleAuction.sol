// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleAuction {
    address public auctioneer; // Người tổ chức phiên đấu giá
    address public highestBidder; // Người thắng đấu giá
    uint public highestBid; // Giá thầu cao nhất
    uint public auctionEndTime; // Thời gian kết thúc phiên đấu giá
    bool public auctionEnded; // Kiểm tra xem phiên đấu giá đã kết thúc chưa

    mapping(address => uint) public bids; // Lưu trữ các giá thầu của các người tham gia

    // Sự kiện khi có người thắng đấu giá
    event HighestBidIncreased(address bidder, uint amount);
    // Sự kiện khi phiên đấu giá kết thúc
    event AuctionEnded(address winner, uint amount);

    // Modifier để chỉ cho phép người tổ chức phiên đấu giá thực hiện một số hành động
    modifier onlyAuctioneer() {
        require(msg.sender == auctioneer, "Chi nguoi to chuc moi co quyen nay.");
        _;
    }

    // Modifier để kiểm tra phiên đấu giá đã kết thúc hay chưa
    modifier hasEnded() {
        require(block.timestamp >= auctionEndTime, "Phien dau gia dang dien ra.");
        _;
    }

    // Constructor để khởi tạo phiên đấu giá
    constructor(uint _biddingTime) {
        auctioneer = msg.sender; // Người tạo hợp đồng là người tổ chức phiên đấu giá
        auctionEndTime = block.timestamp + _biddingTime; // Tính thời gian kết thúc đấu giá
        auctionEnded = false;
    }

    // Hàm để tham gia đấu giá
    function bid() external payable {
        require(block.timestamp < auctionEndTime, "Phin dau gia da ket thuc.");
        require(msg.value > highestBid, "Gia thau phai cao hon gia hien tai.");

        // Trả lại tiền cho người đã thua cuộc
        if (highestBidder != address(0)) {
            payable(highestBidder).transfer(bids[highestBidder]);
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
        bids[msg.sender] = msg.value;

        emit HighestBidIncreased(msg.sender, msg.value);
    }

    // Hàm kết thúc phiên đấu giá và chuyển tiền cho người tổ chức
    function endAuction() external onlyAuctioneer hasEnded {
        require(!auctionEnded, "Phien dau gia da ket thuc.");

        auctionEnded = true;
        emit AuctionEnded(highestBidder, highestBid);

        // Chuyển tiền cho người tổ chức
        payable(auctioneer).transfer(highestBid);
    }

    // Hàm để lấy lại tiền thừa nếu đấu giá không thắng
    function withdraw() external {
        uint amount = bids[msg.sender];
        require(amount > 0, "Khong co tien de rut.");
        require(msg.sender != highestBidder, "ban thang thau.");

        bids[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}
