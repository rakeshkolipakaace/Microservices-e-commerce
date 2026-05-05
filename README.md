# Shipping Service

The Shipping service provides price quote, tracking IDs, and the impression of order fulfillment & shipping processes.
this is for test

## Local

Run the following command to restore dependencies to `vendor/` directory:

    dep ensure --vendor-only

## Build

From `src/shippingservice`, run:

```
docker build ./
```

## Test

```
go test .
```
