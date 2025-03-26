;; Seed Purity Verification Contract
;; Tracks genetic integrity of heritage grains

(define-data-var last-batch-id uint u0)

;; Seed batch structure
(define-map seed-batches
  { batch-id: uint }
  {
    variety-id: uint,
    producer: principal,
    quantity: uint,
    location: (string-ascii 100),
    certification-status: (string-ascii 50)
  }
)

;; Register a new seed batch
(define-public (register-seed-batch
    (variety-id uint)
    (quantity uint)
    (location (string-ascii 100))
  )
  (let
    (
      (new-id (+ (var-get last-batch-id) u1))
    )
    (var-set last-batch-id new-id)
    (map-set seed-batches
      { batch-id: new-id }
      {
        variety-id: variety-id,
        producer: tx-sender,
        quantity: quantity,
        location: location,
        certification-status: "pending"
      }
    )
    (ok new-id)
  )
)

;; Get seed batch details
(define-read-only (get-seed-batch (batch-id uint))
  (map-get? seed-batches { batch-id: batch-id })
)

;; Certify a seed batch
(define-public (certify-batch (batch-id uint))
  (let
    (
      (batch (unwrap! (map-get? seed-batches { batch-id: batch-id }) (err u1)))
    )
    (map-set seed-batches
      { batch-id: batch-id }
      (merge batch {
        certification-status: "certified"
      })
    )
    (ok true)
  )
)

