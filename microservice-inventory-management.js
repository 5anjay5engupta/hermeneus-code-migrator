// JavaScript microservice for inventory management
const express = require('express');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

class Product {
    constructor(id, name, quantity, price, lastUpdated) {
        this.id = id;
        this.name = name;
        this.quantity = quantity;
        this.price = price;
        this.lastUpdated = lastUpdated;
    }
}

class InventoryService {
    constructor() {
        this.products = {};
    }

    updateStock(req, res) {
        const productData = req.body;
        if (!productData || typeof productData !== 'object') {
            res.status(400).send('Invalid JSON');
            return;
        }

        const product = new Product(
            productData.id,
            productData.name,
            productData.quantity,
            productData.price,
            new Date()
        );

        this.products[product.id] = product;

        res.setHeader('Content-Type', 'application/json');
        res.json(product);
    }
}

const inventoryService = new InventoryService();

app.post('/update-stock', (req, res) => inventoryService.updateStock(req, res));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
```