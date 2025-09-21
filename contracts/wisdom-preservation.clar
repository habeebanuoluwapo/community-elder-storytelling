;; wisdom-preservation
;; Contract for preserving, organizing, and sharing wisdom, life lessons, and traditional knowledge from elders

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u200))
(define-constant err-wisdom-not-found (err u201))
(define-constant err-keeper-not-found (err u202))
(define-constant err-invalid-wisdom-type (err u203))
(define-constant err-invalid-access-level (err u204))
(define-constant err-already-registered (err u205))
(define-constant err-wisdom-locked (err u206))
(define-constant err-insufficient-reputation (err u207))
(define-constant err-invalid-status (err u208))

;; Data Maps
(define-map wisdom-keepers
  { keeper: principal }
  {
    name: (string-utf8 100),
    specialization: (string-utf8 100),
    bio: (string-utf8 1000),
    cultural-background: (string-utf8 200),
    years-experience: uint,
    wisdom-count: uint,
    preservation-score: uint,
    community-rating: uint,
    total-ratings: uint,
    verification-status: (string-utf8 20),
    registration-date: uint,
    last-active: uint,
    mentorship-hours: uint,
    languages-spoken: (list 5 (string-utf8 50)),
    areas-of-expertise: (list 10 (string-utf8 100))
  }
)

(define-map wisdom-entries
  { wisdom-id: uint }
  {
    keeper: principal,
    title: (string-utf8 200),
    wisdom-type: (string-utf8 50),
    content-summary: (string-utf8 1000),
    full-content-hash: (optional (string-utf8 64)),
    cultural-context: (string-utf8 500),
    historical-period: (optional (string-utf8 100)),
    applicable-situations: (list 10 (string-utf8 100)),
    key-lessons: (list 5 (string-utf8 200)),
    difficulty-level: uint,
    access-level: (string-utf8 20),
    preservation-status: (string-utf8 20),
    creation-date: uint,
    last-updated: uint,
    view-count: uint,
    application-count: uint,
    wisdom-rating: uint,
    rating-count: uint,
    verification-level: uint,
    source-attribution: (optional (string-utf8 200)),
    related-traditions: (list 5 (string-utf8 100)),
    preservation-urgency: uint
  }
)

(define-map wisdom-collections
  { collection-id: uint }
  {
    curator: principal,
    collection-name: (string-utf8 150),
    theme: (string-utf8 100),
    description: (string-utf8 500),
    cultural-focus: (optional (string-utf8 100)),
    target-audience: (string-utf8 100),
    wisdom-ids: (list 50 uint),
    creation-date: uint,
    is-public: bool,
    access-requirements: (optional (string-utf8 200)),
    completion-certificate: bool,
    total-learners: uint,
    average-completion-rate: uint
  }
)

(define-map wisdom-applications
  { application-id: uint }
  {
    wisdom-id: uint,
    applicant: principal,
    application-context: (string-utf8 500),
    results-achieved: (optional (string-utf8 500)),
    effectiveness-rating: (optional uint),
    application-date: uint,
    outcome-reported: bool,
    shared-publicly: bool,
    follow-up-needed: bool,
    mentor-guidance: (optional (string-utf8 300))
  }
)

(define-map preservation-projects
  { project-id: uint }
  {
    lead-keeper: principal,
    project-name: (string-utf8 150),
    focus-area: (string-utf8 100),
    description: (string-utf8 800),
    target-wisdoms: uint,
    collected-wisdoms: uint,
    participating-keepers: (list 20 principal),
    project-status: (string-utf8 20),
    start-date: uint,
    target-completion: uint,
    community-impact-score: uint,
    funding-needed: (optional uint),
    cultural-significance: uint
  }
)

(define-map wisdom-lineages
  { lineage-id: uint }
  {
    lineage-name: (string-utf8 100),
    origin-keeper: principal,
    tradition-source: (string-utf8 200),
    wisdom-chain: (list 30 uint),
    current-keepers: (list 10 principal),
    preservation-priority: uint,
    lineage-status: (string-utf8 20),
    cultural-significance: (string-utf8 300),
    risk-level: uint,
    documentation-completeness: uint
  }
)

(define-map wisdom-mentorships
  { mentorship-id: uint }
  {
    mentor: principal,
    mentee: principal,
    wisdom-focus: (string-utf8 100),
    sessions-completed: uint,
    sessions-planned: uint,
    mentorship-status: (string-utf8 20),
    start-date: uint,
    progress-notes: (optional (string-utf8 500)),
    mentor-rating: (optional uint),
    mentee-feedback: (optional (string-utf8 300)),
    wisdom-transferred: (list 15 uint)
  }
)

;; Data Variables
(define-data-var next-wisdom-id uint u1)
(define-data-var next-collection-id uint u1)
(define-data-var next-application-id uint u1)
(define-data-var next-project-id uint u1)
(define-data-var next-lineage-id uint u1)
(define-data-var next-mentorship-id uint u1)
(define-data-var total-wisdom-entries uint u0)
(define-data-var total-keepers uint u0)
(define-data-var total-applications uint u0)
(define-data-var preservation-fund uint u0)

;; Private Functions
(define-private (is-valid-wisdom-type (wisdom-type (string-utf8 50)))
  (or (is-eq wisdom-type u"life-lesson")
      (is-eq wisdom-type u"traditional-practice")
      (is-eq wisdom-type u"cultural-knowledge")
      (is-eq wisdom-type u"practical-skill")
      (is-eq wisdom-type u"spiritual-guidance")
      (is-eq wisdom-type u"historical-insight")
      (is-eq wisdom-type u"family-wisdom")
      (is-eq wisdom-type u"professional-knowledge")
      (is-eq wisdom-type u"survival-knowledge")
      (is-eq wisdom-type u"healing-practice")
      (is-eq wisdom-type u"artistic-technique")
      (is-eq wisdom-type u"philosophical-insight")
      (is-eq wisdom-type u"community-guidance")
      (is-eq wisdom-type u"ethical-framework")
      (is-eq wisdom-type u"other"))
)

(define-private (is-valid-access-level (level (string-utf8 20)))
  (or (is-eq level u"public")
      (is-eq level u"community")
      (is-eq level u"verified-only")
      (is-eq level u"restricted")
      (is-eq level u"sacred"))
)

(define-private (is-valid-preservation-status (status (string-utf8 20)))
  (or (is-eq status u"draft")
      (is-eq status u"pending-review")
      (is-eq status u"verified")
      (is-eq status u"published")
      (is-eq status u"archived")
      (is-eq status u"protected"))
)

(define-private (calculate-preservation-score (keeper principal))
  (let
    (
      (keeper-info (unwrap-panic (map-get? wisdom-keepers { keeper: keeper })))
      (wisdom-count (get wisdom-count keeper-info))
      (rating (get community-rating keeper-info))
      (experience (get years-experience keeper-info))
    )
    (+ (* wisdom-count u10) (* rating u5) experience)
  )
)

;; Public Functions
(define-public (register-wisdom-keeper
    (name (string-utf8 100))
    (specialization (string-utf8 100))
    (bio (string-utf8 1000))
    (cultural-background (string-utf8 200))
    (years-experience uint)
    (languages-spoken (list 5 (string-utf8 50)))
    (areas-of-expertise (list 10 (string-utf8 100)))
  )
  (begin
    (asserts! (is-none (map-get? wisdom-keepers { keeper: tx-sender })) err-already-registered)
    
    (map-set wisdom-keepers
      { keeper: tx-sender }
      {
        name: name,
        specialization: specialization,
        bio: bio,
        cultural-background: cultural-background,
        years-experience: years-experience,
        wisdom-count: u0,
        preservation-score: years-experience,
        community-rating: u0,
        total-ratings: u0,
        verification-status: u"pending",
        registration-date: block-height,
        last-active: block-height,
        mentorship-hours: u0,
        languages-spoken: languages-spoken,
        areas-of-expertise: areas-of-expertise
      }
    )
    
    (var-set total-keepers (+ (var-get total-keepers) u1))
    (ok true)
  )
)

(define-public (preserve-wisdom
    (title (string-utf8 200))
    (wisdom-type (string-utf8 50))
    (content-summary (string-utf8 1000))
    (full-content-hash (optional (string-utf8 64)))
    (cultural-context (string-utf8 500))
    (historical-period (optional (string-utf8 100)))
    (applicable-situations (list 10 (string-utf8 100)))
    (key-lessons (list 5 (string-utf8 200)))
    (difficulty-level uint)
    (access-level (string-utf8 20))
    (source-attribution (optional (string-utf8 200)))
    (related-traditions (list 5 (string-utf8 100)))
    (preservation-urgency uint)
  )
  (let
    (
      (wisdom-id (var-get next-wisdom-id))
      (keeper-info (unwrap! (map-get? wisdom-keepers { keeper: tx-sender }) err-keeper-not-found))
    )
    (asserts! (is-valid-wisdom-type wisdom-type) err-invalid-wisdom-type)
    (asserts! (is-valid-access-level access-level) err-invalid-access-level)
    (asserts! (and (>= difficulty-level u1) (<= difficulty-level u5)) (err u209))
    (asserts! (and (>= preservation-urgency u1) (<= preservation-urgency u10)) (err u210))
    
    ;; Create wisdom entry
    (map-set wisdom-entries
      { wisdom-id: wisdom-id }
      {
        keeper: tx-sender,
        title: title,
        wisdom-type: wisdom-type,
        content-summary: content-summary,
        full-content-hash: full-content-hash,
        cultural-context: cultural-context,
        historical-period: historical-period,
        applicable-situations: applicable-situations,
        key-lessons: key-lessons,
        difficulty-level: difficulty-level,
        access-level: access-level,
        preservation-status: u"draft",
        creation-date: block-height,
        last-updated: block-height,
        view-count: u0,
        application-count: u0,
        wisdom-rating: u0,
        rating-count: u0,
        verification-level: u0,
        source-attribution: source-attribution,
        related-traditions: related-traditions,
        preservation-urgency: preservation-urgency
      }
    )
    
    ;; Update keeper's wisdom count and preservation score
    (let
      (
        (new-wisdom-count (+ (get wisdom-count keeper-info) u1))
        (new-preservation-score (calculate-preservation-score tx-sender))
      )
      (map-set wisdom-keepers
        { keeper: tx-sender }
        (merge keeper-info {
          wisdom-count: new-wisdom-count,
          preservation-score: new-preservation-score,
          last-active: block-height
        })
      )
    )
    
    (var-set next-wisdom-id (+ wisdom-id u1))
    (var-set total-wisdom-entries (+ (var-get total-wisdom-entries) u1))
    
    (ok wisdom-id)
  )
)

(define-public (publish-wisdom (wisdom-id uint))
  (let
    (
      (wisdom (unwrap! (map-get? wisdom-entries { wisdom-id: wisdom-id }) err-wisdom-not-found))
    )
    (asserts! (is-eq tx-sender (get keeper wisdom)) err-unauthorized)
    (asserts! (is-eq (get preservation-status wisdom) u"draft") err-invalid-status)
    
    (map-set wisdom-entries
      { wisdom-id: wisdom-id }
      (merge wisdom {
        preservation-status: u"published",
        last-updated: block-height
      })
    )
    (ok true)
  )
)

(define-public (apply-wisdom
    (wisdom-id uint)
    (application-context (string-utf8 500))
  )
  (let
    (
      (wisdom (unwrap! (map-get? wisdom-entries { wisdom-id: wisdom-id }) err-wisdom-not-found))
      (application-id (var-get next-application-id))
    )
    (asserts! (is-eq (get preservation-status wisdom) u"published") err-invalid-status)
    
    ;; Record wisdom application
    (map-set wisdom-applications
      { application-id: application-id }
      {
        wisdom-id: wisdom-id,
        applicant: tx-sender,
        application-context: application-context,
        results-achieved: none,
        effectiveness-rating: none,
        application-date: block-height,
        outcome-reported: false,
        shared-publicly: false,
        follow-up-needed: true,
        mentor-guidance: none
      }
    )
    
    ;; Update wisdom application count
    (map-set wisdom-entries
      { wisdom-id: wisdom-id }
      (merge wisdom { application-count: (+ (get application-count wisdom) u1) })
    )
    
    (var-set next-application-id (+ application-id u1))
    (var-set total-applications (+ (var-get total-applications) u1))
    
    (ok application-id)
  )
)

(define-public (report-wisdom-outcome
    (application-id uint)
    (results-achieved (string-utf8 500))
    (effectiveness-rating uint)
    (shared-publicly bool)
  )
  (let
    (
      (application (unwrap! (map-get? wisdom-applications { application-id: application-id }) (err u211)))
      (wisdom (unwrap! (map-get? wisdom-entries { wisdom-id: (get wisdom-id application) }) err-wisdom-not-found))
    )
    (asserts! (is-eq tx-sender (get applicant application)) err-unauthorized)
    (asserts! (and (>= effectiveness-rating u1) (<= effectiveness-rating u5)) (err u212))
    
    ;; Update application with results
    (map-set wisdom-applications
      { application-id: application-id }
      (merge application {
        results-achieved: (some results-achieved),
        effectiveness-rating: (some effectiveness-rating),
        outcome-reported: true,
        shared-publicly: shared-publicly,
        follow-up-needed: false
      })
    )
    
    ;; Update wisdom rating if this is a new rating
    (if (is-none (get effectiveness-rating application))
      (let
        (
          (current-rating (get wisdom-rating wisdom))
          (rating-count (get rating-count wisdom))
          (new-rating-count (+ rating-count u1))
          (new-average (/ (+ (* current-rating rating-count) effectiveness-rating) new-rating-count))
        )
        (map-set wisdom-entries
          { wisdom-id: (get wisdom-id application) }
          (merge wisdom {
            wisdom-rating: new-average,
            rating-count: new-rating-count
          })
        )
        true
      )
      true
    )
    
    (ok true)
  )
)

(define-public (create-preservation-project
    (project-name (string-utf8 150))
    (focus-area (string-utf8 100))
    (description (string-utf8 800))
    (target-wisdoms uint)
    (target-completion uint)
    (funding-needed (optional uint))
    (cultural-significance uint)
  )
  (let
    (
      (project-id (var-get next-project-id))
      (keeper-info (unwrap! (map-get? wisdom-keepers { keeper: tx-sender }) err-keeper-not-found))
    )
    (asserts! (>= (get preservation-score keeper-info) u50) err-insufficient-reputation)
    
    (map-set preservation-projects
      { project-id: project-id }
      {
        lead-keeper: tx-sender,
        project-name: project-name,
        focus-area: focus-area,
        description: description,
        target-wisdoms: target-wisdoms,
        collected-wisdoms: u0,
        participating-keepers: (list tx-sender),
        project-status: u"active",
        start-date: block-height,
        target-completion: target-completion,
        community-impact-score: u0,
        funding-needed: funding-needed,
        cultural-significance: cultural-significance
      }
    )
    
    (var-set next-project-id (+ project-id u1))
    (ok project-id)
  )
)

(define-public (start-mentorship
    (mentee principal)
    (wisdom-focus (string-utf8 100))
    (sessions-planned uint)
  )
  (let
    (
      (mentorship-id (var-get next-mentorship-id))
      (mentor-info (unwrap! (map-get? wisdom-keepers { keeper: tx-sender }) err-keeper-not-found))
    )
    (asserts! (>= (get preservation-score mentor-info) u30) err-insufficient-reputation)
    
    (map-set wisdom-mentorships
      { mentorship-id: mentorship-id }
      {
        mentor: tx-sender,
        mentee: mentee,
        wisdom-focus: wisdom-focus,
        sessions-completed: u0,
        sessions-planned: sessions-planned,
        mentorship-status: u"active",
        start-date: block-height,
        progress-notes: none,
        mentor-rating: none,
        mentee-feedback: none,
        wisdom-transferred: (list)
      }
    )
    
    (var-set next-mentorship-id (+ mentorship-id u1))
    (ok mentorship-id)
  )
)

(define-public (verify-wisdom
    (wisdom-id uint)
    (verification-level uint)
  )
  (let
    (
      (wisdom (unwrap! (map-get? wisdom-entries { wisdom-id: wisdom-id }) err-wisdom-not-found))
      (verifier-info (unwrap! (map-get? wisdom-keepers { keeper: tx-sender }) err-keeper-not-found))
    )
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (asserts! (and (>= verification-level u1) (<= verification-level u5)) (err u213))
    
    (map-set wisdom-entries
      { wisdom-id: wisdom-id }
      (merge wisdom {
        verification-level: verification-level,
        preservation-status: u"verified",
        last-updated: block-height
      })
    )
    (ok true)
  )
)

;; Read Functions
(define-read-only (get-wisdom-keeper (keeper principal))
  (map-get? wisdom-keepers { keeper: keeper })
)

(define-read-only (get-wisdom-entry (wisdom-id uint))
  (map-get? wisdom-entries { wisdom-id: wisdom-id })
)

(define-read-only (get-wisdom-collection (collection-id uint))
  (map-get? wisdom-collections { collection-id: collection-id })
)

(define-read-only (get-wisdom-application (application-id uint))
  (map-get? wisdom-applications { application-id: application-id })
)

(define-read-only (get-preservation-project (project-id uint))
  (map-get? preservation-projects { project-id: project-id })
)

(define-read-only (get-wisdom-mentorship (mentorship-id uint))
  (map-get? wisdom-mentorships { mentorship-id: mentorship-id })
)

(define-read-only (get-preservation-stats)
  {
    total-wisdom-entries: (var-get total-wisdom-entries),
    total-keepers: (var-get total-keepers),
    total-applications: (var-get total-applications),
    preservation-fund: (var-get preservation-fund),
    next-wisdom-id: (var-get next-wisdom-id),
    next-project-id: (var-get next-project-id),
    next-mentorship-id: (var-get next-mentorship-id)
  }
)

