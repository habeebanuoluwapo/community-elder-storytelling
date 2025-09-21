;; story-registry
;; Contract for registering and managing elder stories, oral histories, and community narratives

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u100))
(define-constant err-story-not-found (err u101))
(define-constant err-storyteller-not-found (err u102))
(define-constant err-invalid-category (err u103))
(define-constant err-invalid-privacy-level (err u104))
(define-constant err-already-registered (err u105))

;; Data Maps
(define-map storytellers
  { storyteller: principal }
  {
    name: (string-utf8 100),
    age: (optional uint),
    bio: (string-utf8 1000),
    background: (string-utf8 500),
    location: (string-utf8 100),
    languages: (list 5 (string-utf8 50)),
    specialties: (list 10 (string-utf8 100)),
    total-stories: uint,
    total-listeners: uint,
    average-rating: uint,
    total-ratings: uint,
    registration-date: uint,
    is-active: bool,
    preferred-topics: (list 15 (string-utf8 100)),
    availability: (string-utf8 200)
  }
)

(define-map stories
  { story-id: uint }
  {
    storyteller: principal,
    title: (string-utf8 200),
    description: (string-utf8 1000),
    category: (string-utf8 50),
    themes: (list 10 (string-utf8 100)),
    time-period: (optional (string-utf8 100)),
    location-setting: (optional (string-utf8 100)),
    language: (string-utf8 50),
    privacy-level: (string-utf8 20),
    content-hash: (optional (string-utf8 64)),
    duration-minutes: (optional uint),
    creation-date: uint,
    last-updated: uint,
    view-count: uint,
    favorite-count: uint,
    rating: uint,
    rating-count: uint,
    is-published: bool,
    cultural-context: (optional (string-utf8 500)),
    historical-significance: (optional (string-utf8 300))
  }
)

(define-map story-collections
  { collection-id: uint }
  {
    curator: principal,
    collection-name: (string-utf8 150),
    description: (string-utf8 500),
    theme: (string-utf8 100),
    story-ids: (list 50 uint),
    creation-date: uint,
    is-public: bool,
    view-count: uint,
    contributor-count: uint
  }
)

(define-map storyteller-stories
  { storyteller: principal }
  { story-ids: (list 100 uint) }
)

(define-map story-interactions
  { interaction-id: uint }
  {
    story-id: uint,
    listener: principal,
    interaction-type: (string-utf8 20),
    timestamp: uint,
    notes: (optional (string-utf8 500)),
    rating: (optional uint),
    feedback: (optional (string-utf8 1000))
  }
)

(define-map story-tags
  { tag: (string-utf8 50) }
  {
    usage-count: uint,
    related-stories: (list 20 uint)
  }
)

(define-map featured-stories
  { featured-id: uint }
  {
    story-id: uint,
    featured-by: principal,
    feature-reason: (string-utf8 300),
    feature-date: uint,
    duration-days: uint,
    view-boost: uint
  }
)

;; Data Variables
(define-data-var next-story-id uint u1)
(define-data-var next-collection-id uint u1)
(define-data-var next-interaction-id uint u1)
(define-data-var next-featured-id uint u1)
(define-data-var total-stories uint u0)
(define-data-var total-storytellers uint u0)
(define-data-var total-interactions uint u0)
(define-data-var total-collections uint u0)

;; Private Functions
(define-private (is-valid-category (category (string-utf8 50)))
  (or (is-eq category u"personal-history")
      (is-eq category u"family-stories")
      (is-eq category u"community-events")
      (is-eq category u"cultural-traditions")
      (is-eq category u"historical-accounts")
      (is-eq category u"life-lessons")
      (is-eq category u"migration-stories")
      (is-eq category u"work-experiences")
      (is-eq category u"folklore-legends")
      (is-eq category u"recipes-cooking")
      (is-eq category u"celebrations-rituals")
      (is-eq category u"challenges-overcome")
      (is-eq category u"wisdom-advice")
      (is-eq category u"childhood-memories")
      (is-eq category u"other"))
)

(define-private (is-valid-privacy-level (level (string-utf8 20)))
  (or (is-eq level u"public")
      (is-eq level u"community")
      (is-eq level u"family")
      (is-eq level u"private"))
)

(define-private (is-valid-interaction-type (interaction-type (string-utf8 20)))
  (or (is-eq interaction-type u"listen")
      (is-eq interaction-type u"favorite")
      (is-eq interaction-type u"share")
      (is-eq interaction-type u"comment")
      (is-eq interaction-type u"rating"))
)

;; Public Functions
(define-public (register-storyteller
    (name (string-utf8 100))
    (age (optional uint))
    (bio (string-utf8 1000))
    (background (string-utf8 500))
    (location (string-utf8 100))
    (languages (list 5 (string-utf8 50)))
    (specialties (list 10 (string-utf8 100)))
    (preferred-topics (list 15 (string-utf8 100)))
    (availability (string-utf8 200))
  )
  (begin
    (asserts! (is-none (map-get? storytellers { storyteller: tx-sender })) err-already-registered)
    
    (map-set storytellers
      { storyteller: tx-sender }
      {
        name: name,
        age: age,
        bio: bio,
        background: background,
        location: location,
        languages: languages,
        specialties: specialties,
        total-stories: u0,
        total-listeners: u0,
        average-rating: u0,
        total-ratings: u0,
        registration-date: block-height,
        is-active: true,
        preferred-topics: preferred-topics,
        availability: availability
      }
    )
    
    (var-set total-storytellers (+ (var-get total-storytellers) u1))
    (ok true)
  )
)

(define-public (register-story
    (title (string-utf8 200))
    (description (string-utf8 1000))
    (category (string-utf8 50))
    (themes (list 10 (string-utf8 100)))
    (time-period (optional (string-utf8 100)))
    (location-setting (optional (string-utf8 100)))
    (language (string-utf8 50))
    (privacy-level (string-utf8 20))
    (content-hash (optional (string-utf8 64)))
    (duration-minutes (optional uint))
    (cultural-context (optional (string-utf8 500)))
    (historical-significance (optional (string-utf8 300)))
  )
  (let
    (
      (story-id (var-get next-story-id))
      (storyteller-info (unwrap! (map-get? storytellers { storyteller: tx-sender }) err-storyteller-not-found))
      (current-stories (default-to { story-ids: (list) }
        (map-get? storyteller-stories { storyteller: tx-sender })))
    )
    (asserts! (is-valid-category category) err-invalid-category)
    (asserts! (is-valid-privacy-level privacy-level) err-invalid-privacy-level)
    
    ;; Register story
    (map-set stories
      { story-id: story-id }
      {
        storyteller: tx-sender,
        title: title,
        description: description,
        category: category,
        themes: themes,
        time-period: time-period,
        location-setting: location-setting,
        language: language,
        privacy-level: privacy-level,
        content-hash: content-hash,
        duration-minutes: duration-minutes,
        creation-date: block-height,
        last-updated: block-height,
        view-count: u0,
        favorite-count: u0,
        rating: u0,
        rating-count: u0,
        is-published: false,
        cultural-context: cultural-context,
        historical-significance: historical-significance
      }
    )
    
    ;; Update storyteller's story list
    (map-set storyteller-stories
      { storyteller: tx-sender }
      { story-ids: (unwrap! (as-max-len?
          (append (get story-ids current-stories) story-id) u100)
        (err u106)) }
    )
    
    ;; Update storyteller's total stories count
    (map-set storytellers
      { storyteller: tx-sender }
      (merge storyteller-info { total-stories: (+ (get total-stories storyteller-info) u1) })
    )
    
    ;; Update counters
    (var-set next-story-id (+ story-id u1))
    (var-set total-stories (+ (var-get total-stories) u1))
    
    (ok story-id)
  )
)

(define-public (publish-story (story-id uint))
  (let
    (
      (story (unwrap! (map-get? stories { story-id: story-id }) err-story-not-found))
    )
    (asserts! (is-eq tx-sender (get storyteller story)) err-unauthorized)
    
    (map-set stories
      { story-id: story-id }
      (merge story { is-published: true, last-updated: block-height })
    )
    (ok true)
  )
)

(define-public (create-collection
    (collection-name (string-utf8 150))
    (description (string-utf8 500))
    (theme (string-utf8 100))
    (is-public bool)
  )
  (let
    (
      (collection-id (var-get next-collection-id))
    )
    (map-set story-collections
      { collection-id: collection-id }
      {
        curator: tx-sender,
        collection-name: collection-name,
        description: description,
        theme: theme,
        story-ids: (list),
        creation-date: block-height,
        is-public: is-public,
        view-count: u0,
        contributor-count: u0
      }
    )
    
    (var-set next-collection-id (+ collection-id u1))
    (var-set total-collections (+ (var-get total-collections) u1))
    (ok collection-id)
  )
)

(define-public (add-story-to-collection (collection-id uint) (story-id uint))
  (let
    (
      (collection (unwrap! (map-get? story-collections { collection-id: collection-id }) (err u107)))
      (story (unwrap! (map-get? stories { story-id: story-id }) err-story-not-found))
      (current-stories (get story-ids collection))
    )
    (asserts! (is-eq tx-sender (get curator collection)) err-unauthorized)
    (asserts! (get is-published story) (err u108))
    (asserts! (< (len current-stories) u50) (err u109))
    
    (map-set story-collections
      { collection-id: collection-id }
      (merge collection {
        story-ids: (unwrap! (as-max-len? (append current-stories story-id) u50) (err u110))
      })
    )
    (ok true)
  )
)

(define-public (interact-with-story
    (story-id uint)
    (interaction-type (string-utf8 20))
    (notes (optional (string-utf8 500)))
    (rating (optional uint))
    (feedback (optional (string-utf8 1000)))
  )
  (let
    (
      (story (unwrap! (map-get? stories { story-id: story-id }) err-story-not-found))
      (interaction-id (var-get next-interaction-id))
      (storyteller-info (unwrap! (map-get? storytellers { storyteller: (get storyteller story) }) err-storyteller-not-found))
    )
    (asserts! (is-valid-interaction-type interaction-type) (err u111))
    (asserts! (get is-published story) (err u112))
    
    ;; Record interaction
    (map-set story-interactions
      { interaction-id: interaction-id }
      {
        story-id: story-id,
        listener: tx-sender,
        interaction-type: interaction-type,
        timestamp: block-height,
        notes: notes,
        rating: rating,
        feedback: feedback
      }
    )
    
    ;; Update story metrics based on interaction type
    (if (is-eq interaction-type u"listen")
      (map-set stories
        { story-id: story-id }
        (merge story { view-count: (+ (get view-count story) u1) })
      )
      (if (is-eq interaction-type u"favorite")
        (map-set stories
          { story-id: story-id }
          (merge story { favorite-count: (+ (get favorite-count story) u1) })
        )
        true
      )
    )
    
    ;; Handle rating if provided
    (if (is-some rating)
      (let
        (
          (rating-value (unwrap-panic rating))
          (current-rating (get rating story))
          (rating-count (get rating-count story))
          (new-rating-count (+ rating-count u1))
          (new-average (/ (+ (* current-rating rating-count) rating-value) new-rating-count))
        )
        (asserts! (and (>= rating-value u1) (<= rating-value u5)) (err u113))
        
        ;; Update story rating
        (map-set stories
          { story-id: story-id }
          (merge story {
            rating: new-average,
            rating-count: new-rating-count
          })
        )
        
        ;; Update storyteller rating
        (let
          (
            (storyteller-current-rating (get average-rating storyteller-info))
            (storyteller-total-ratings (get total-ratings storyteller-info))
            (storyteller-new-total (+ storyteller-total-ratings u1))
            (storyteller-new-avg (/ (+ (* storyteller-current-rating storyteller-total-ratings) rating-value) storyteller-new-total))
          )
          (map-set storytellers
            { storyteller: (get storyteller story) }
            (merge storyteller-info {
              average-rating: storyteller-new-avg,
              total-ratings: storyteller-new-total
            })
          )
        )
        true
      )
      true
    )
    
    (var-set next-interaction-id (+ interaction-id u1))
    (var-set total-interactions (+ (var-get total-interactions) u1))
    (ok interaction-id)
  )
)

(define-public (feature-story
    (story-id uint)
    (feature-reason (string-utf8 300))
    (duration-days uint)
  )
  (let
    (
      (story (unwrap! (map-get? stories { story-id: story-id }) err-story-not-found))
      (featured-id (var-get next-featured-id))
    )
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (asserts! (get is-published story) (err u114))
    
    (map-set featured-stories
      { featured-id: featured-id }
      {
        story-id: story-id,
        featured-by: tx-sender,
        feature-reason: feature-reason,
        feature-date: block-height,
        duration-days: duration-days,
        view-boost: u0
      }
    )
    
    (var-set next-featured-id (+ featured-id u1))
    (ok featured-id)
  )
)

(define-public (update-storyteller-profile
    (name (string-utf8 100))
    (bio (string-utf8 1000))
    (specialties (list 10 (string-utf8 100)))
    (availability (string-utf8 200))
  )
  (let
    (
      (storyteller-info (unwrap! (map-get? storytellers { storyteller: tx-sender }) err-storyteller-not-found))
    )
    (map-set storytellers
      { storyteller: tx-sender }
      (merge storyteller-info {
        name: name,
        bio: bio,
        specialties: specialties,
        availability: availability
      })
    )
    (ok true)
  )
)

;; Read Functions
(define-read-only (get-storyteller (storyteller-principal principal))
  (map-get? storytellers { storyteller: storyteller-principal })
)

(define-read-only (get-story (story-id uint))
  (map-get? stories { story-id: story-id })
)

(define-read-only (get-story-collection (collection-id uint))
  (map-get? story-collections { collection-id: collection-id })
)

(define-read-only (get-storyteller-stories (storyteller-principal principal))
  (map-get? storyteller-stories { storyteller: storyteller-principal })
)

(define-read-only (get-story-interaction (interaction-id uint))
  (map-get? story-interactions { interaction-id: interaction-id })
)

(define-read-only (get-featured-story (featured-id uint))
  (map-get? featured-stories { featured-id: featured-id })
)

(define-read-only (get-registry-stats)
  {
    total-stories: (var-get total-stories),
    total-storytellers: (var-get total-storytellers),
    total-interactions: (var-get total-interactions),
    total-collections: (var-get total-collections),
    next-story-id: (var-get next-story-id),
    next-collection-id: (var-get next-collection-id),
    next-interaction-id: (var-get next-interaction-id),
    next-featured-id: (var-get next-featured-id)
  }
)

