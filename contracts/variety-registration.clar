;; Variety Registration Contract
;; Records details of traditional grain types

(define-data-var last-variety-id uint u0)

;; Grain variety structure
(define-map varieties
  { variety-id: uint }
  {
    name: (string-ascii 100),
    description: (string-ascii 500),
    origin: (string-ascii 100),
    registrar: principal
  }
)

;; Register a new grain variety
(define-public (register-variety
    (name (string-ascii 100))
    (description (string-ascii 500))
    (origin (string-ascii 100))
  )
  (let
    (
      (new-id (+ (var-get last-variety-id) u1))
    )
    (var-set last-variety-id new-id)
    (map-set varieties
      { variety-id: new-id }
      {
        name: name,
        description: description,
        origin: origin,
        registrar: tx-sender
      }
    )
    (ok new-id)
  )
)

;; Get variety details
(define-read-only (get-variety (variety-id uint))
  (map-get? varieties { variety-id: variety-id })
)

