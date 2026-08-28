# AtlasCommerce Business Documentation

## Document Information

* **System:** AtlasCommerce
* **Document Type:** Business Documentation
* **Language:** English
* **Status:** Final
* **Purpose:** Describe how AtlasCommerce operates from a business perspective.

---

## Table of Contents

[1. AtlasCommerce Overview](#1-atlascommerce-overview)

[2. Business Scope and Operating Model](#2-business-scope-and-operating-model)

[3. Product Catalog and Merchandising](#3-product-catalog-and-merchandising)
   - [3.1 Products and Brands](#31-products-and-brands)
   - [3.2 Product Variants](#32-product-variants)
   - [3.3 Product Attributes](#33-product-attributes)
   - [3.4 Product Categories](#34-product-categories)
   - [3.5 Product Images](#35-product-images)
   - [3.6 Product Pricing](#36-product-pricing)

[4. Customer Management](#4-customer-management)
   - [4.1 Identified and Unidentified Customers](#41-identified-and-unidentified-customers)
   - [4.2 Customer Types](#42-customer-types)
   - [4.3 Customer Documents](#43-customer-documents)
   - [4.4 Telephone Contacts](#44-telephone-contacts)
   - [4.5 Email Addresses](#45-email-addresses)
   - [4.6 Customer Addresses](#46-customer-addresses)

[5. Sales and Transaction Lifecycle](#5-sales-and-transaction-lifecycle)
   - [5.1 Transaction](#51-transaction)
   - [5.2 Sales Channels](#52-sales-channels)
   - [5.3 Transaction Statuses](#53-transaction-statuses)
   - [5.4 Transaction Items](#54-transaction-items)
   - [5.5 Transaction Amounts](#55-transaction-amounts)

[6. Inventory Management](#6-inventory-management)
   - [6.1 Current Inventory Position](#61-current-inventory-position)
   - [6.2 Inventory Movements](#62-inventory-movements)
   - [6.3 Inventory Movement Reasons](#63-inventory-movement-reasons)

[7. Inventory Reservation Lifecycle](#7-inventory-reservation-lifecycle)
   - [7.1 Purpose of a Reservation](#71-purpose-of-a-reservation)
   - [7.2 Reservation Period](#72-reservation-period)
   - [7.3 Reservation Statuses](#73-reservation-statuses)

[8. Payment Processing](#8-payment-processing)
   - [8.1 Payments and Payment Attempts](#81-payments-and-payment-attempts)
   - [8.2 Payment Methods](#82-payment-methods)
   - [8.3 Installments](#83-installments)
   - [8.4 Payment Statuses](#84-payment-statuses)

[9. Refund Processing](#9-refund-processing)
   - [9.1 Refund Events](#91-refund-events)
   - [9.2 Partial and Full Refunds](#92-partial-and-full-refunds)
   - [9.3 Refund Reasons](#93-refund-reasons)

[10. Shipping and Fulfillment](#10-shipping-and-fulfillment)
    - [10.1 When Shipping Exists](#101-when-shipping-exists)
    - [10.2 One Transaction, One Delivery](#102-one-transaction-one-delivery)
    - [10.3 Delivery Address](#103-delivery-address)
    - [10.4 Shipment Methods](#104-shipment-methods)
    - [10.5 Shipping Charge](#105-shipping-charge)
    - [10.6 Delivery Estimate and Tracking](#106-delivery-estimate-and-tracking)
    - [10.7 Shipment Statuses](#107-shipment-statuses)

[11. Cross-Domain Business Rules](#11-cross-domain-business-rules)
    - [11.1 Transaction Status Is Not Payment Status](#111-transaction-status-is-not-payment-status)
    - [11.2 Transaction Status Is Not Reservation Status](#112-transaction-status-is-not-reservation-status)
    - [11.3 Transaction Status Is Not Shipment Status](#113-transaction-status-is-not-shipment-status)
    - [11.4 Payment Status Is Not Refund History](#114-payment-status-is-not-refund-history)
    - [11.5 Current Inventory Is Not Inventory History](#115-current-inventory-is-not-inventory-history)

[12. Historical Business Information](#12-historical-business-information)
    - [12.1 Historical Sale Prices](#121-historical-sale-prices)
    - [12.2 Historical Catalog Prices](#122-historical-catalog-prices)
    - [12.3 Historical Customer Addresses](#123-historical-customer-addresses)
    - [12.4 Historical Inventory Events](#124-historical-inventory-events)
    - [12.5 Historical Payment and Refund Events](#125-historical-payment-and-refund-events)
    - [12.6 Why Historical Truth Matters](#126-why-historical-truth-matters)

[13. End-to-End Business Scenarios](#13-end-to-end-business-scenarios)
    - [13.1 Online Purchase Successfully Delivered](#131-online-purchase-successfully-delivered)
    - [13.2 In-Store Purchase with Immediate Pickup](#132-in-store-purchase-with-immediate-pickup)
    - [13.3 Payment Attempt Declined and Retried](#133-payment-attempt-declined-and-retried)
    - [13.4 Reservation Released Before Expiration](#134-reservation-released-before-expiration)
    - [13.5 Reservation Expires](#135-reservation-expires)
    - [13.6 Partial Refund Followed by Additional Refund](#136-partial-refund-followed-by-additional-refund)
    - [13.7 Customer Changes an Address After a Purchase](#137-customer-changes-an-address-after-a-purchase)

[14. Business Rules Summary](#14-business-rules-summary)

[15. Current Scope Boundaries](#15-current-scope-boundaries)

---

# 1. AtlasCommerce Overview

AtlasCommerce is a retail commerce platform focused on beauty and personal care products.

The business supports two sales channels:

* **ONLINE**, for purchases originated through the online sales channel.
* **STORE**, for purchases made directly at the physical store.

The platform manages the commercial journey from the product catalog through the completion of a sale, including customer information, inventory availability and reservation, payment processing, refunds, and shipping when delivery is required.

Not every sale follows exactly the same operational path.

An online purchase requires a delivery process, while a customer purchasing directly at the store takes the products immediately and does not require shipment.

The different parts of the business also maintain their own lifecycle. A sale, payment, inventory reservation, and shipment do not share a single status. Each represents a different business process and can therefore progress independently while remaining associated with the same commercial transaction.

AtlasCommerce also preserves relevant historical business information. Changes to current prices, customer information, addresses, inventory, or other operational data must not alter the facts that describe transactions that already occurred.

---

# 2. Business Scope and Operating Model

AtlasCommerce represents a deliberately focused retail operation.

Its current scope includes:

* management of products and their sellable variants;
* product categorization and commercial presentation;
* identified and unidentified customer purchases;
* online and in-store sales;
* transaction-level and item-level pricing and discounts;
* inventory availability;
* inventory reservations;
* inventory movements;
* multiple payment attempts or operations associated with a sale;
* payment refunds;
* shipping for purchases that require delivery;
* preservation of historical commercial information.

The current business model intentionally avoids unnecessary complexity.

AtlasCommerce operates with a single inventory context. Multi-store and multi-warehouse inventory distribution are outside the current scope.

A transaction that requires delivery has at most one shipment. Splitting a single purchase across multiple delivery destinations is also outside the current model. When products need to be sent to different destinations, they must be represented by separate transactions.

The objective is to represent a coherent retail business without modeling operational possibilities for which there is no current business requirement.

---

# 3. Product Catalog and Merchandising

## 3.1 Products and Brands

A product represents the commercial identity of an item offered by AtlasCommerce.

Products may be associated with a brand, allowing the catalog to organize merchandise consistently by commercial manufacturer or brand identity.

The product itself does not necessarily represent the exact item purchased by a customer. Products may have multiple sellable variants.

For example, a lipstick can represent the general commercial product, while different colors represent the specific variants available for purchase.

A simplified example would be:

- **Product:** Lipstick
- **Variant:** Beige
- **Variant:** Red
- **Variant:** Pink

The product defines what is being sold commercially, while the variants identify the specific versions the customer can actually purchase.

---

## 3.2 Product Variants

A product variant represents a specific sellable version of a product.

Variants allow AtlasCommerce to distinguish commercial variations such as color, size, volume, finish, or other characteristics relevant to a particular product.

Each sellable variant has its own SKU and is treated independently where necessary for pricing, inventory, reservations, and sales.

This distinction allows two variants of the same product to have different prices and different inventory availability.

Customers therefore purchase product variants rather than an abstract product definition.

For example, consider a lipstick offered in different colors and sizes:

- **Product:** Lipstick
- **Variant:** Beige / 10 g
- **Variant:** Red / 10 g
- **Variant:** Beige / 5 g

Each of these variants represents a distinct sellable item. They may have their own SKU, price, and inventory availability even though they all belong to the same product.

This means that the Beige / 10 g variant may be available in inventory while the Red / 10 g variant is out of stock, or one variant may have a different price from the others.

---

## 3.3 Product Attributes

AtlasCommerce uses reusable product attributes to describe characteristics that vary among products and variants.

An attribute represents a characteristic such as color, volume, size, or finish.

Each attribute can have a controlled set of possible values, and sellable variants can be associated with the values that describe them.

This approach allows the catalog to represent different types of beauty and personal care products without requiring every product to share the same fixed characteristics.

For example, consider the **Beige / 10 g** lipstick variant introduced earlier.

It can be described using attributes and their corresponding values:

- **Color:** Beige
- **Weight:** 10 g

Another variant of the same lipstick could be:

- **Color:** Red
- **Weight:** 10 g

Both variants belong to the same product, but their attribute values describe what makes each sellable version distinct.

The same attribute, such as **Color**, can also be reused to describe variants of other products when that characteristic is relevant.

---

## 3.4 Product Categories

Products can be classified into categories to support catalog organization.

Categories may form a hierarchy, allowing broader classifications to contain more specific classifications.

A product may participate in more than one category when appropriate.

The category structure therefore describes how products are presented and organized commercially without changing the identity of the product itself.

For example, the lipstick used in the previous examples could appear in two different category hierarchies:

**By product type:**

- **Makeup**
  - **Lips**
    - **Lipstick**

**By commercial collection:**

- **Makeup**
  - **Long-Lasting**
    - **Lipstick**

Both classifications refer to the same product. The product does not need to be duplicated simply because customers can discover it through different areas of the catalog.

Categories therefore provide different ways to organize and navigate the catalog while the product retains a single commercial identity.

---

## 3.5 Product Images

Products may have multiple images used for catalog presentation.

Images can have a defined presentation order, and one active image may be designated as the primary image for a product.

The primary image represents the preferred visual presentation of the product, while additional images can provide alternative views or supporting presentation material.

Inactive images can remain historically known without participating in the current catalog presentation.

---

## 3.6 Product Pricing

Prices belong to sellable product variants.

AtlasCommerce maintains price history rather than treating the current price as the only price that has ever existed.

A price is applicable during a defined validity period. A new commercial price can therefore become effective without overwriting the previous price.

Historical price periods must not overlap for the same variant.

This allows AtlasCommerce to distinguish between:

* the price currently offered in the catalog; and
* prices that were commercially valid in the past.

The price recorded in an actual sale is preserved separately as part of that sale and does not change when the catalog price changes later.

By preserving these historical prices, AtlasCommerce can also determine which catalog price was valid for a product variant during a specific period.

This creates a real history of how the commercial value of a variant changed over time, making it possible to answer questions such as:

- What was the price of this variant six months ago?
- When did its price increase or decrease?
- How has its commercial value changed over time?

Combined with the price preserved in each actual sale, this also makes it possible to distinguish between the price that was offered in the catalog and the price that the customer actually paid at a given point in time.

---

# 4. Customer Management

## 4.1 Identified and Unidentified Customers

Customer identification requirements depend on the sales channel.

For **ONLINE** purchases, the customer must be registered and identified. The online sales process requires customer information and a valid customer address for delivery.

For **STORE** purchases, customer identification is optional. A customer can purchase products directly at the physical store and take them immediately without providing personal information or having a registered customer profile.

For example, a customer who walks into the store, purchases a lipstick, pays for it, and leaves with the product can complete the transaction without being registered in AtlasCommerce.

If the customer chooses to identify themselves during an in-store purchase, the transaction can be associated with their existing customer profile.

This distinction allows AtlasCommerce to support the different requirements of online and physical retail without creating customer records when the business process does not require them.

Maintaining an identified purchase history can allow AtlasCommerce to support customer-oriented commercial initiatives defined by the business. For example, the company may choose to offer promotions or discounts based on purchase history, customer preferences, birthdays, or other commercial criteria.

These initiatives are optional business strategies rather than guaranteed benefits of customer identification. AtlasCommerce does not assume that an identified customer will always receive promotions, discounts, or other advantages.

---

## 4.2 Customer Types

Identified customers can currently be classified as:

* **INDIVIDUAL**
* **COMPANY**

An individual represents a natural person.

A company represents a legal entity.

The information applicable to a customer can depend on the customer type. For example, a birth date is meaningful for an individual but is not used as a company foundation date.

---

## 4.3 Customer Documents

An identified customer may have one or more identification documents.

The currently supported document types depend on the customer type:

**INDIVIDUAL**

- **CPF**
- **RG**
- **CNH**
- **PASSPORT**

**COMPANY**

- **CNPJ**

Documents are maintained separately from the customer's core identity because a customer can possess more than one type of document.

A document value must not be duplicated for the same document type across customers.

This allows AtlasCommerce to maintain controlled customer identification without embedding every possible document directly into the customer profile.

---

## 4.4 Telephone Contacts

An identified customer may have telephone contact information.

The currently supported contact classifications are:

* **PHONE**
* **MOBILE**

A customer can have multiple telephone contacts, but at most one can be designated as the customer's primary contact.

---

## 4.5 Email Addresses

An identified customer may have multiple email addresses, but at most one can be designated as the customer's primary email.

The same email address may legitimately be associated with different customers. This supports situations such as family members or dependents sharing a common email address.

---

## 4.6 Customer Addresses

An identified customer may maintain multiple addresses, but at most one address can be designated as the customer's primary address.

The customer may also maintain other addresses for different purposes, such as delivery to another location.

Address history is preserved.

When a material address change occurs, the historical address used by previous business operations must not be transformed retroactively into the new address.

Instead, the previous customer-address relationship can become inactive while the new address becomes available for future operations.

This distinction is especially important for shipping because a past delivery must continue to represent the destination that was actually selected at the time.

---

# 5. Sales and Transaction Lifecycle

## 5.1 Transaction

A Transaction represents a commercial sale processed by AtlasCommerce.

Every transaction records when the commercial event occurred, how it originated, its current business status, and its monetary totals.

Customer identification depends on the sales channel. ONLINE transactions require an identified customer, while customer identification is optional for STORE transactions.

Each transaction can contain one or more purchased items.

For example, consider two different sales:

**Identified online sale**

A registered customer purchases a lipstick through the ONLINE channel. The transaction is associated with that customer and preserves the commercial details of the purchase. Because it is an online sale, the customer is identified and the purchase follows the delivery process.

**Unidentified in-store sale**

A customer walks into the physical store, purchases a lipstick, pays for it, and takes the product immediately without providing personal information. The transaction is recorded normally through the STORE channel, but it is not associated with a registered customer.

Both are valid AtlasCommerce transactions. Customer identification provides additional business context when available, but an unidentified in-store sale remains a complete commercial transaction.

---

## 5.2 Sales Channels

Transactions currently originate through one of two channels:

* **ONLINE**
* **STORE**

The channel identifies how the sale originated.

An ONLINE transaction represents a purchase made through the online channel.

A STORE transaction represents a purchase made directly at the physical store.

For the current AtlasCommerce scope, a STORE purchase is treated as immediate pickup: the customer purchases the products and takes them directly from the store.

Consequently, STORE transactions do not require a shipment process.

---

## 5.3 Transaction Statuses

The transaction lifecycle currently uses the following statuses:

### PENDING

The transaction exists but has not yet reached the point at which the sale is considered confirmed.

### CONFIRMED

The transaction has been successfully confirmed after payment approval but the products have not yet been delivered to the customer.

This status applies to ONLINE purchases, where payment confirmation and physical delivery occur at different moments. The sale has been commercially confirmed and can continue through the fulfillment process, but its lifecycle is not yet complete.

STORE purchases do not require this intermediate state because the customer receives the products immediately as part of the in-store sales process.

### COMPLETED

The transaction has reached the end of its commercial lifecycle and the customer has received the purchased products.

For an ONLINE purchase, the transaction reaches COMPLETED after the products have been successfully delivered to the customer.

For a STORE purchase, payment and product handover occur as part of the same in-store process. The transaction can therefore reach COMPLETED without requiring the intermediate CONFIRMED state used by online purchases.

### CANCELLED

The transaction was intentionally cancelled and will not continue through its normal commercial lifecycle.

### FAILED

The transaction could not be successfully completed because the sales process failed.

A failed transaction is distinct from a deliberate cancellation.

---

## 5.4 Transaction Items

Each transaction contains the product variants included in the purchase.

For every item, AtlasCommerce preserves:

* the variant purchased;
* the quantity;
* the unit price applied to the sale;
* the unit discount applied to the sale.

This information represents the financial conditions actually applied when the transaction occurred.

A later catalog price change therefore does not alter the historical price of an existing transaction.

The same principle applies to discounts: the discount recorded in the sale represents what was actually granted at that time.

---

## 5.5 Transaction Amounts

AtlasCommerce distinguishes the gross value of a transaction from the discount granted.

The gross amount represents the commercial value before transaction-level discounts.

The discount amount represents the monetary reduction applied to the transaction.

Shipping charges are not treated as part of the core transaction amount. When shipping is required, its charge belongs to the delivery process.

This keeps the value of merchandise and the cost of delivery as distinct business concepts.

---

# 6. Inventory Management

## 6.1 Current Inventory Position

Inventory is managed by sellable product variant.

For each variant, AtlasCommerce distinguishes:

* quantity physically available in usable inventory;
* quantity currently reserved for sales.

Reserved quantity cannot exceed the quantity available in inventory.

The reservation component allows the business to distinguish inventory that physically exists from inventory that has already been committed to an active sales process.

Inventory represents usable merchandise. Products that are damaged, lost, or otherwise unavailable for sale must not remain represented as usable stock.

---

## 6.2 Inventory Movements

Changes to inventory are recorded as business movements.

Each movement identifies:

* the product variant affected;
* the quantity entering or leaving inventory;
* the reason for the movement;
* when the movement occurred.

Positive quantities represent entries into inventory.

Negative quantities represent exits from inventory.

When a movement originates from a specific purchased item, it can remain associated with that sale item.

For example, a customer purchases two units of the Beige / 10 g lipstick variant.

When the products leave usable inventory as part of that sale, the corresponding inventory movement can remain associated with the specific transaction item that contained those two units.

This relationship makes it possible to understand not only that inventory decreased, but also which sale caused that decrease.

This allows AtlasCommerce to preserve not only the current inventory position but also the business events that caused inventory to change.

---

## 6.3 Inventory Movement Reasons

AtlasCommerce currently recognizes the following inventory movement reasons, organized according to whether they increase or decrease usable inventory.

### Inventory Inflows

#### PURCHASE_RECEIPT

Usable merchandise entered inventory as the result of receiving purchased stock.

#### CUSTOMER_RETURN

Merchandise returned by a customer re-entered usable inventory.

#### FOUND_INTERNAL

Previously unavailable merchandise was found internally and returned to usable inventory.

#### INVENTORY_ADJUSTMENT_IN

A controlled inventory adjustment increased usable inventory.

### Inventory Outflows

#### SALE

Inventory left usable stock as the result of a customer sale.

#### DAMAGED_IN_TRANSIT

Merchandise became unavailable because it was damaged during transportation.

#### DAMAGED_INTERNAL

Merchandise became unavailable because it was damaged internally.

#### LOSS_IN_TRANSIT

Merchandise became unavailable because it was lost during transportation.

#### LOSS_INTERNAL

Merchandise became unavailable because of an internal loss.

#### INVENTORY_ADJUSTMENT_OUT

A controlled inventory adjustment reduced usable inventory.

These reasons distinguish the business cause of a stock change from the quantity change itself.

Additional operational context may be recorded when a movement requires explanation beyond its standardized reason.

---

# 7. Inventory Reservation Lifecycle

## 7.1 Purpose of a Reservation

A reservation represents inventory committed to a specific transaction item.

Its purpose is to distinguish merchandise that remains physically present in inventory but has already been allocated to an active sales process.

Each transaction item can have at most one inventory reservation.

The reserved variant must be the same variant represented by the transaction item.

A reservation always represents a positive quantity.

---

## 7.2 Reservation Period

An inventory reservation is created for a limited period of time.

While the reservation is valid, the reserved quantity remains committed to the corresponding transaction item and is not considered available for another sale.

Each reservation therefore has an expiration time that defines how long the inventory can remain reserved.

For example, if two units of the Beige / 10 g lipstick are reserved until 2:30 PM, those two units remain committed to that transaction until the reservation is consumed, released, or reaches its expiration time.

If the sale proceeds successfully, the reservation can be consumed.

If the reserved inventory is no longer needed before the expiration time, the reservation can be released.

If neither occurs before the reservation period ends, the reservation expires.

This prevents inventory from remaining indefinitely committed to a sales process that was not completed.

---

## 7.3 Reservation Statuses

Reservations currently use four statuses:

### ACTIVE

The inventory remains reserved for the transaction item.

An active reservation has not been closed.

### CONSUMED

The reservation has fulfilled its purpose and the reserved inventory has been consumed by the sales process.

### RELEASED

The inventory is no longer required by the transaction item and has been released from the reservation.

Released inventory can return to availability according to the inventory process.

### EXPIRED

The reservation remained unresolved beyond its allowed reservation period and expired.

Expired reservations are preserved as business events rather than being treated as ordinary releases.

This distinction is important because an expired reservation indicates that inventory remained committed until the allowed reservation period ended without the sales process resolving it.

A RELEASED reservation, on the other hand, indicates that the inventory was intentionally made available again before expiration because it was no longer required.

Keeping these outcomes separate allows AtlasCommerce to identify how often reservations expire, understand inventory that remained unnecessarily committed, and support future analysis of situations in which sales were not completed within the expected reservation period.

---

# 8. Payment Processing

## 8.1 Payments and Payment Attempts

Payment processing has its own lifecycle and is separate from the transaction lifecycle.

A transaction may have multiple payment records associated with it. Each payment represents an individual financial operation and preserves its own payment method, amount, status, and relevant business events.

This allows AtlasCommerce to preserve the complete payment history of a sale rather than keeping only its final financial outcome.

For example, a customer may attempt to pay for an ONLINE purchase using a credit card:

1. The first CREDIT_CARD payment attempt is declined.
2. The customer tries again using another credit card.
3. The second payment is approved.

Both payment attempts remain part of the transaction history. The approved payment does not replace or erase the declined attempt.

Multiple payments can also represent a sale paid using more than one payment method when the business process allows it.

For example, an in-store purchase could be paid using:

- part of the amount in CASH; and
- the remaining amount using CREDIT_CARD.

Each payment is recorded separately while remaining associated with the same transaction.

This distinction allows AtlasCommerce to represent what actually happened financially during a sale, including unsuccessful attempts and multiple successful payment operations when applicable.

---

## 8.2 Payment Methods

AtlasCommerce currently supports the following payment methods:

- **PIX**
- **CREDIT_CARD**
- **DEBIT_CARD**
- **CASH**

The payment method identifies how each individual payment associated with a transaction was made.

When a transaction uses more than one payment method, each payment preserves the method and amount used for that portion of the sale.

---

## 8.3 Installments

When applicable, a payment can be divided into multiple installments.

For example, a CREDIT_CARD payment of R$ 600.00 could be paid in six installments of R$ 100.00.

For payments made in a single amount, no installment information is required.

---

## 8.4 Payment Statuses

Each payment operation has its own status.

The currently supported statuses are:

### PENDING

The payment attempt exists but has not yet reached a final approval or rejection state.

### APPROVED

The payment was successfully approved.

### DECLINED

The payment attempt was rejected.

A declined payment does not necessarily mean that the transaction itself has failed because another payment attempt may occur.

### CANCELLED

The payment operation was cancelled.

### PARTIALLY_REFUNDED

Part of the amount previously paid has been refunded while part remains unrefunded.

### REFUNDED

The applicable paid amount has been fully refunded.

These statuses describe payment processing only. They do not replace or duplicate the status of the sale itself.

---

# 9. Refund Processing

## 9.1 Refund Events

Refunds are associated with payments rather than directly with the transaction.

A payment may have multiple refund events.

This allows a payment to be refunded incrementally instead of requiring every refund to return the entire amount at once.

Each refund identifies:

* the amount refunded;
* the reason;
* when the refund occurred.

A refund cannot occur before the payment attempt that originated it.

The cumulative value of refunds associated with a payment cannot exceed the amount of that payment.

---

## 9.2 Partial and Full Refunds

Because multiple refund events can be associated with the same payment, AtlasCommerce supports both partial and full refund scenarios.

For example, a payment may first receive a partial refund and later receive another refund.

The collection of refund events preserves what actually happened rather than replacing earlier refund activity with only the latest total.

The payment lifecycle can therefore distinguish between a payment that has been partially refunded and one that has been fully refunded.

---

## 9.3 Refund Reasons

AtlasCommerce currently recognizes the following refund reasons:

### CUSTOMER_RETURN

A refund was issued because merchandise was returned by the customer.

### DUPLICATE_CHARGE

A refund was issued to correct a duplicated payment charge.

### FRAUD

A refund was issued as a result of a fraud-related event.

### OPERATIONAL_ERROR

A refund was required because of an operational error.

### ORDER_CANCELLATION

A refund was issued because the underlying commercial transaction was cancelled.

The refund reason describes why money was returned. It is distinct from the status of the payment and from the status of the transaction.

---

# 10. Shipping and Fulfillment

## 10.1 When Shipping Exists

Shipment represents the delivery process for transactions that require physical transportation to a customer address.

Not every transaction has a shipment.

For the current business model:

* **ONLINE transactions require a delivery process.**
* **STORE transactions represent immediate pickup and do not generate a shipment.**

This distinction prevents an in-store purchase from creating an artificial logistics process simply because shipping exists elsewhere in the business.

---

## 10.2 One Transaction, One Delivery

A transaction can have at most one shipment.

AtlasCommerce does not currently split a transaction across multiple delivery destinations or multiple shipment processes.

If a customer needs products delivered to different destinations, those purchases must be represented as separate transactions.

This is a deliberate simplification of the current business model.

---

## 10.3 Delivery Address

A shipment uses the customer address selected for that delivery.

Once a shipment has been associated with a destination, that information becomes part of the historical record of the purchase.

Even if the customer later moves or removes that location from their current list of addresses, the destination used for the original shipment remains preserved.

This ensures that AtlasCommerce can always determine where a previous purchase was actually sent, regardless of later changes to the customer's current information.

---

## 10.4 Shipment Methods

AtlasCommerce currently supports:

* **PAC**
* **SEDEX**

The selected shipment method represents the delivery service chosen for the transaction.

---

## 10.5 Shipping Charge

The shipping charge belongs to the shipment.

It is not part of the merchandise amount recorded as the core transaction value.

This separation allows AtlasCommerce to distinguish between what the customer paid for merchandise and what was charged for delivery.

---

## 10.6 Delivery Estimate and Tracking

A shipment can preserve the estimated delivery date presented for the delivery process.

Once tracking information becomes available, a tracking code can also be associated with the shipment.

AtlasCommerce can additionally distinguish when the shipment was posted to the delivery provider and when it was successfully delivered.

---

## 10.7 Shipment Statuses

Shipments currently use the following statuses:

### PENDING

The delivery process exists but the shipment has not yet been posted to the delivery provider.

### POSTED

The shipment has been handed over for transportation.

### DELIVERED

The shipment was successfully delivered to the recipient.

### CANCELLED

The shipment process was cancelled.

### RETURNED

The shipment was returned rather than completing its intended delivery lifecycle.

Shipment status represents logistics only. A DELIVERED shipment is not itself the same concept as a CONFIRMED or COMPLETED transaction.

---

# 11. Cross-Domain Business Rules

AtlasCommerce intentionally keeps the lifecycle of each business process separate.

This is one of the central concepts of the platform.

## 11.1 Transaction Status Is Not Payment Status

A Transaction describes the commercial sale.

A Payment describes an individual financial operation associated with that sale.

A declined payment attempt does not automatically mean that the transaction must be treated as failed, because another payment attempt may follow.

Similarly, a refunded payment and a cancelled transaction describe different business facts even when they may occur as part of the same scenario.

For example, consider an ONLINE purchase where the first CREDIT_CARD payment attempt is declined.

The payment is recorded as DECLINED, but the transaction can remain PENDING while the customer tries another payment method. If a subsequent PIX payment is approved, the transaction can continue normally and become CONFIRMED.

The declined payment therefore describes what happened to that specific financial attempt, while the transaction status describes the state of the sale as a whole.

As another example, consider a completed sale that later requires a partial refund.

The Payment may become PARTIALLY_REFUNDED while the Transaction remains COMPLETED because the customer received the products and the original sale was completed successfully.

The refund changes the financial history of the sale, but it does not automatically rewrite what happened in the commercial transaction.

---

## 11.2 Transaction Status Is Not Reservation Status

A reservation describes inventory temporarily committed to a transaction item.

Its lifecycle answers a different question from the transaction lifecycle.

A reservation can be ACTIVE, CONSUMED, RELEASED, or EXPIRED. These states should not be inferred solely from the transaction status.

For example, consider an ONLINE purchase while the customer is still completing the payment process.

The Transaction may remain PENDING while the inventory required for one of its items is already protected by an ACTIVE reservation.

In this situation:

- **Transaction:** PENDING
- **Reservation:** ACTIVE

The transaction has not yet been confirmed, but the inventory is temporarily committed so that the same quantity is not considered available for another sale.

As another example, consider a transaction that does not proceed within the allowed reservation period.

The reservation may become EXPIRED because the inventory remained committed until the reservation period ended. The Transaction, however, does not become EXPIRED because expiration is not a transaction status.

In this situation:

- **Transaction:** PENDING
- **Reservation:** EXPIRED

The expired reservation describes what happened to the inventory commitment. The transaction status continues to describe what happened to the sale itself.

Similarly, when a sale proceeds successfully, its reservation can become CONSUMED while the Transaction continues through its own lifecycle.

These examples demonstrate why reservation status and transaction status must remain separate: one describes the commitment of inventory, while the other describes the commercial sale.

---

## 11.3 Transaction Status Is Not Shipment Status

A Transaction describes the commercial lifecycle of a sale, while a Shipment describes the logistics lifecycle required to deliver an ONLINE purchase.

Although these processes are related, their statuses represent different business events and should not be interpreted as the same state.

For example, consider an ONLINE purchase after its payment has been approved but before the products have been delivered:

- **Transaction:** CONFIRMED
- **Shipment:** PENDING

The sale has been commercially confirmed, but the delivery process has not yet progressed to transportation.

Later, after the package is handed over for delivery:

- **Transaction:** CONFIRMED
- **Shipment:** POSTED

The logistics process has advanced, but the commercial lifecycle of the transaction is still waiting for the customer to receive the products.

When the shipment is successfully delivered:

- **Shipment:** DELIVERED
- **Transaction:** COMPLETED

In an ONLINE purchase, successful delivery is the business event that allows the transaction to reach the end of its commercial lifecycle.

STORE purchases demonstrate the distinction from another perspective.

A STORE transaction does not have a Shipment because the customer receives the products immediately at the physical store. The transaction can therefore reach COMPLETED without any shipment status existing.

These scenarios demonstrate why Transaction and Shipment require separate lifecycles: the Transaction describes the sale as a whole, while the Shipment describes only the delivery process when one is required.

---

## 11.4 Payment Status Is Not Refund History

A Payment status represents the current financial state of a payment.

Refund events preserve the individual occurrences in which money was returned to the customer.

Although refund events can affect the current Payment status, they represent different business information and must be preserved separately.

For example, consider an approved payment of R$ 500.00 that later receives a refund of R$ 100.00:

- **Original Payment:** R$ 500.00
- **Refund:** R$ 100.00
- **Payment Status:** PARTIALLY_REFUNDED

The Payment status indicates that only part of the original amount has been refunded.

The Refund history provides the additional information of how much was returned, when it happened, and why.

Now consider the same payment receiving another refund later:

- **Original Payment:** R$ 500.00
- **First Refund:** R$ 100.00
- **Second Refund:** R$ 400.00
- **Payment Status:** REFUNDED

The current Payment status now indicates that the payment has been fully refunded, but it does not replace the two individual refund events that produced that result.

Preserving both events makes it possible to understand that the R$ 500.00 was not returned in a single operation, but through two separate refunds that may have occurred at different times and for different reasons.

This distinction allows AtlasCommerce to answer two different business questions:

- **Payment status:** What is the current financial state of this payment?
- **Refund history:** How, when, and why was money returned to the customer?

---

## 11.5 Current Inventory Is Not Inventory History

The current inventory position answers:

> How much usable inventory do we have now, and how much of it is reserved?

Inventory movements answer:

> What business events caused inventory to increase or decrease?

Reservations answer:

> Which transaction items currently have, or previously had, inventory committed to them?

These are complementary views of the inventory business process and should not be treated as interchangeable.

---

# 12. Historical Business Information

AtlasCommerce preserves historical information whenever changing the current state would otherwise alter the meaning of a past business event.

This principle applies across multiple business areas.

## 12.1 Historical Sale Prices

A transaction item preserves the unit price and discount actually applied when the customer purchased the product.

Changing the current catalog price does not change previous sales.

---

## 12.2 Historical Catalog Prices

Product variant prices have their own periods of validity.

A new price does not require the previous commercial price to disappear from history.

---

## 12.3 Historical Customer Addresses

A shipment must continue to represent the address selected for that delivery.

A later customer address change must not rewrite the destination of a previous shipment.

---

## 12.4 Historical Inventory Events

The current inventory quantity alone is insufficient to explain how inventory reached its present state.

Inventory movements preserve the events that changed stock.

Reservations preserve the lifecycle of inventory that was committed to sales.

---

## 12.5 Historical Payment and Refund Events

Multiple payment attempts can remain associated with the same transaction.

A failed or declined attempt does not need to disappear when a later attempt succeeds.

Likewise, individual refund events remain available even when the payment's current state eventually becomes fully refunded.

---

## 12.6 Why Historical Truth Matters

The objective is not merely to retain old data.

The objective is to preserve the business facts as they were when an event occurred.

A future analytical process must be able to answer questions such as:

* What price was actually charged?
* What discount was granted?
* Which variant was purchased?
* What inventory movement resulted from the operation?
* Which payment attempts occurred?
* How much was refunded and why?
* Which address received the shipment?
* Which shipment method was used?
* How long did reservation, payment, or delivery processes take?

Those answers must not change merely because today's catalog, customer profile, price, or operational state is different.

---

# 13. End-to-End Business Scenarios

The following scenarios illustrate how the different AtlasCommerce business processes can participate in the same commercial journey.

They describe the relationships among the processes without defining application orchestration rules that have not yet been established.

## 13.1 Online Purchase Successfully Delivered

A customer purchases one or more product variants through the ONLINE channel.

The transaction records the commercial conditions of the sale, including the products, quantities, prices, and discounts applicable at that moment.

Inventory required by the transaction items can be committed through reservations.

Payment processing occurs independently and can contain one or more payment attempts until the financial process reaches the appropriate outcome.

When reserved inventory is successfully used by the sale, the reservation can be consumed and the corresponding inventory change can be represented as a SALE movement.

Because the purchase is online, a shipment is associated with the transaction.

The shipment preserves the selected delivery address, shipment method, shipping charge, delivery estimate, and later the available tracking and delivery events.

The shipment progresses independently through its logistics lifecycle until delivery or another terminal outcome.

The transaction itself progresses through its own lifecycle. After payment approval, the ONLINE transaction can become CONFIRMED while awaiting delivery.

When the shipment is successfully delivered to the customer, the transaction can reach COMPLETED, representing the end of its commercial lifecycle.

---

## 13.2 In-Store Purchase with Immediate Pickup

A customer purchases products directly through the STORE channel.

The customer may be identified, but identification is not required.

The transaction preserves the purchased variants, quantities, prices, and discounts.

Payment is processed using the applicable payment method.

Inventory leaves usable stock as part of the sale.

The customer takes the products immediately.

No shipment is created because there is no separate delivery process.

The absence of a shipment is therefore an expected business condition, not missing information.

---

## 13.3 Payment Attempt Declined and Retried

A transaction reaches payment processing.

The first payment attempt is declined.

The declined attempt remains part of the financial history of the transaction.

Because a transaction can have multiple payment operations, another payment attempt may subsequently occur.

The later attempt has its own payment method, amount, status, and event times.

A successful later attempt does not erase the declined attempt.

This preserves the actual payment journey associated with the sale.

---

## 13.4 Reservation Released Before Expiration

Inventory is reserved for a transaction item.

Before the reservation reaches its expiration time, the inventory is no longer required by that sales process.

The reservation is released and its lifecycle is closed.

The event remains distinguishable from an expired reservation because the inventory was explicitly released rather than remaining committed until the reservation period elapsed.

---

## 13.5 Reservation Expires

Inventory is reserved for a transaction item but the reservation is not consumed or released within its allowed period.

The reservation reaches its expiration point and is eventually closed as EXPIRED.

The expiration remains part of the reservation history.

This allows expired reservations to be distinguished from successful consumption and explicit release.

---

## 13.6 Partial Refund Followed by Additional Refund

A previously approved payment requires a partial refund.

AtlasCommerce records the individual refund event, its amount, reason, and time.

The payment can then represent a partially refunded state.

If another refund is later required, a second refund event can be recorded.

The cumulative refunds can never exceed the amount of the original payment.

When the applicable payment amount has been fully refunded, the payment can represent the fully refunded state while preserving every individual refund event that led to that result.

---

## 13.7 Customer Changes an Address After a Purchase

A customer completes an online purchase using one of their addresses as the shipment destination.

The shipment retains that destination as part of the historical delivery context.

Later, the customer materially changes their address.

The previous historical address is preserved rather than being rewritten.

The new address becomes available for future commercial operations without altering the destination recorded for the earlier shipment.

---

# 14. Business Rules Summary

The current AtlasCommerce business model is governed by the following core principles:

### Sales and Customers

- AtlasCommerce supports **ONLINE** and **STORE** sales.
- ONLINE purchases require an identified customer.
- STORE purchases may be completed without identifying or registering the customer.
- Identified customers may be **INDIVIDUAL** or **COMPANY**.
- Identified customers can maintain multiple telephone contacts, email addresses, and addresses, with at most one primary entry of each type.
- Identifying an in-store customer allows their purchase history to be associated with their profile and may support optional commercial initiatives defined by the business.

### Products and Pricing

- Products can have multiple sellable variants.
- Product variants represent the specific items customers purchase.
- Pricing is maintained by product variant.
- Historical catalog prices are preserved rather than overwritten.
- Sales preserve the prices and discounts actually applied at the time of purchase.

### Transactions

- A Transaction represents the commercial sale and has its own lifecycle.
- A PENDING transaction represents a sale that has not yet been confirmed.
- For ONLINE purchases, a transaction becomes CONFIRMED after successful payment approval while the products are still awaiting delivery.
- An ONLINE transaction becomes COMPLETED after the products have been successfully delivered to the customer.
- STORE purchases do not require the intermediate CONFIRMED state because payment and product handover occur as part of the in-store process.
- A STORE transaction can therefore reach COMPLETED without requiring a Shipment.

### Inventory

- Inventory is controlled by product variant.
- Inventory distinguishes usable quantity from reserved quantity.
- Reserved inventory cannot exceed usable inventory.
- Inventory changes are classified by standardized movement reasons.
- Inventory movements preserve the business events that caused stock to increase or decrease.
- Products that are damaged, lost, or otherwise unavailable for sale must not remain represented as usable inventory.

### Inventory Reservations

- Each transaction item can have at most one inventory reservation.
- A reservation must refer to the same product variant as its transaction item.
- Reservations exist for a limited period and prevent committed inventory from being considered available for another sale.
- Reservations can be **ACTIVE**, **CONSUMED**, **RELEASED**, or **EXPIRED**.
- RELEASED and EXPIRED represent different business outcomes and remain distinguishable in reservation history.

### Payments

- A transaction may have multiple payment attempts or payment operations.
- Multiple payments may represent successive attempts or, when applicable, a sale divided among more than one payment method.
- Supported payment methods are **PIX**, **CREDIT_CARD**, **DEBIT_CARD**, and **CASH**.
- Payments maintain a lifecycle independent from the transaction lifecycle.
- A declined payment does not necessarily mean that the transaction has failed because another payment attempt may occur.
- When applicable, a payment can be divided into multiple installments.

### Refunds

- Refunds belong to individual payments rather than directly to the transaction.
- A payment can have multiple refund events.
- Refunds can be partial or total.
- Total refunds associated with a payment cannot exceed the amount of that payment.
- Individual refund events remain preserved even when the payment eventually becomes fully refunded.
- Payment status represents the current financial state, while refund history preserves how, when, and why money was returned.

### Shipping and Fulfillment

- ONLINE purchases require a delivery process in the current business model.
- STORE purchases represent immediate pickup and do not generate a Shipment.
- A transaction can have at most one Shipment.
- Multiple delivery destinations require separate transactions.
- Supported shipment methods are **PAC** and **SEDEX**.
- Shipping charges belong to the delivery process rather than the merchandise transaction amount.
- Historical delivery destinations remain preserved even if the customer later moves or removes that location from their current address list.
- For an ONLINE purchase, successful delivery allows the Transaction to reach COMPLETED.

### Independent Business Lifecycles

- Transaction, Payment, Inventory Reservation, and Shipment statuses represent different business processes and must not be treated as interchangeable.
- A change in one lifecycle does not automatically imply the same state change in another.
- Relationships among these processes preserve how the complete commercial journey occurred.

### Historical Business Truth

- AtlasCommerce preserves historical business facts rather than rewriting them when current information changes.
- Historical prices, sale conditions, inventory movements, reservations, payment attempts, refunds, and delivery destinations remain interpretable after the original business event.
- Current operational information and historical business information serve different purposes and are preserved accordingly.

---

# 15. Current Scope Boundaries

AtlasCommerce intentionally does not attempt to represent every feature that could exist in a large retail platform.

The current model does not define:

* multiple stores or warehouses with independent inventory positions;
* split shipments for a single transaction;
* multiple delivery destinations within a single transaction;
* shipment processes for in-store purchases;
* a mandatory identified customer for every sale;
* a fixed compatibility matrix between sales channels and payment methods;
* detailed application orchestration for every transition among transaction, reservation, payment, and shipment statuses.

These boundaries are deliberate.

New business capabilities should be introduced when a concrete operational or analytical requirement justifies them rather than being added solely because they might exist in a more complex commerce platform.

---

## Closing Principle

AtlasCommerce treats a sale as a collection of related but distinct business processes.

The commercial transaction describes the sale.

Its items preserve what was purchased and under which financial conditions.

Inventory describes what is available and how stock changes.

Reservations describe inventory committed to specific sale items.

Payments describe the financial attempts and outcomes associated with the sale.

Refunds describe money returned after payment.

Shipping describes the logistics process when delivery is required.

Customer and catalog information provide the business context in which those events occur.

Keeping these concepts distinct while preserving their relationships allows AtlasCommerce to represent both the current operational state and the historical truth of the business events that produced it.
