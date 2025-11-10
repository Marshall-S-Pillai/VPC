GUVI HCL : Mini-Hackhaton
==============================
Framework : POM with Page Factory & Maven Project(no cucumber)
1) Package-1 : pages
1.1) multiple page files to be created for each of the webpages of the AUT.
1.2) To perform these user actions, locators are needed. For that,we will be using a page
factory.
2) Package-2 : tests
2.1) It can have multiple TestNG class files.
2.2) Each TestNG class file will contain the test methods(@Test). Use the various testng
annotations as needed.
3) Package-3 : Utilities
3.1) class_file : base.java file: This should contain the launch_chrome & launch_edge browser
methods. All the test cases to run on both browsers.
3.2) Methods for explicit wait & fluent waits. Use them wherever they are needed.
3.3) Method for java script executor. Use it wherever it is needed.
URL : https://letcode.in/
On home page
Verify the following on home page
Test Case-1 : verify the existence of the text - “Products”
Use the wait method and wait for the existence of “Products”.
Go to the cart page before adding the product to the cart & take a screenshot.Give a filename -
“Cart_BeforeAddingProduct”. Click on the “Products” link on the cart page and come back to the
home page.
On the home page, Click on a product price of any product and the individual product page
appears.
On Individual Product Page
Test Case-2 : verify the existence of the text - “Men's clothing”
Use the wait method and wait for the existence of “Men's clothing”.
Read the product name & the price. Use this product name & the price as expected values.
Add the product to the cart & go to the cart page.
On cart page,
Take a screenshot of the cart page with the product added to the cart.
Test Case-3 : verify the existence of the text - “Shopping Cart”.
Read the actual values of product name, quantity, price & total.
Use 4 test methods to individually verify product name, quantity, price & total
