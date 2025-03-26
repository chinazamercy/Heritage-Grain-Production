;; Growing Protocol Contract
;; Documents cultivation practices for specific varieties

(define-data-var last-protocol-id uint u0)

;; Protocol structure
(define-map protocols
  { protocol-id: uint }
  {
    variety-id: uint,
    name: (string-ascii 100),
    planting-instructions: (string-ascii 500),
    harvesting-guidelines: (string-ascii 500),
    creator: principal
  }
)

;; Create a new growing protocol
(define-public (create-protocol
    (variety-id uint)
    (name (string-ascii 100))
    (planting-instructions (string-ascii 500))
    (harvesting-guidelines (string-ascii 500))
  )
  (let
    (
      (new-id (+ (var-get last-protocol-id) u1))
    )
    (var-set last-protocol-id new-id)
    (map-set protocols
      { protocol-id: new-id }
      {
        variety-id: variety-id,
        name: name,
        planting-instructions: planting-instructions,
        harvesting-guidelines: harvesting-guidelines,
        creator: tx-sender
      }
    )
    (ok new-id)
  )
)

;; Get protocol details
(define-read-only (get-protocol (protocol-id uint))
  (map-get? protocols { protocol-id: protocol-id })
)

