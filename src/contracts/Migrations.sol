pragma solidity ^0.5.0;

contract Marketplace {
    string public name;
    uint256 public productCount = 0;

    //mapping
    mapping(uint256 => Product) public products;

    struct Product {
        uint256 id;
        string name;
        uint256 price;
        address payable owner;
        bool purchased;
    }

    event ProductCreated(
        uint256 id,
        string name,
        uint256 price,
        address payable owner,
        bool purchased
    );

    event ProductPurchased(
        uint256 id,
        string name,
        uint256 price,
        address payable owner,
        bool purchased
    );

    constructor() public {
        name = "Marketplace";
    }

    function createProduct(string memory _name, uint256 _price) public {
        // Require a valid name
        require(bytes(_name).length > 0);
        // Require a valid price
        require(_price > 0);
        // Increment product count
        productCount++;
        // Create the product
        products[productCount] = Product(
            productCount,
            _name,
            _price,
            msg.sender,
            false
        );
        // Trigger an event
        emit ProductCreated(productCount, _name, _price, msg.sender, false);
    }

    function purchaseProduct(uint256 _id) public payable {
        //fetch product
        Product memory _product = products[_id];
        //fetch owner
        address payable _seller = _product.owner;
        require(_product.id > 0 && _product.id <= productCount);
        // Require that there is enough Ether in the transaction
        require(msg.value >= _product.price);
        // Require that the product has not been purchased already
        require(!_product.purchased);
        // Require that the buyer is not the seller
        require(_seller != msg.sender);
        // Transfer ownership to the buyer

        //make the purches
        _product.owner = msg.sender;
        //make as purchase
        _product.purchased = true;
        //update product in mappping
        products[_id] = _product;
        //pay the seller
        address(_seller).transfer(msg.value);
        //trigger event
        emit ProductPurchased(
            productCount,
            _product.name,
            _product.price,
            msg.sender,
            true
        );
    }
}
