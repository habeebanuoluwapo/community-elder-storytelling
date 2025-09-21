;; intergenerational-sharing
;; Contract for facilitating connections, mentoring, and knowledge transfer between different generations

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u300))
(define-constant err-connection-not-found (err u301))
(define-constant err-participant-not-found (err u302))
(define-constant err-invalid-generation (err u303))
(define-constant err-invalid-connection-type (err u304))
(define-constant err-already-connected (err u305))
(define-constant err-session-not-found (err u306))
(define-constant err-invalid-status (err u307))
(define-constant err-program-not-found (err u308))
(define-constant err-capacity-exceeded (err u309))
(define-constant err-insufficient-reputation (err u310))

;; Data Maps
(define-map generation-participants
  { participant: principal }
  {
    name: (string-utf8 100),
    generation: (string-utf8 20),
    age-range: (string-utf8 20),
    bio: (string-utf8 1000),
    interests: (list 10 (string-utf8 100)),
    skills-to-share: (list 15 (string-utf8 100)),
    skills-to-learn: (list 15 (string-utf8 100)),
    cultural-background: (string-utf8 200),
    languages: (list 5 (string-utf8 50)),
    availability: (string-utf8 200),
    connection-preference: (string-utf8 50),
    total-connections: uint,
    active-connections: uint,
    mentoring-hours: uint,
    community-rating: uint,
    total-ratings: uint,
    registration-date: uint,
    last-active: uint,
    verified-elder: bool,
    mentor-status: (string-utf8 20)
  }
)

(define-map intergenerational-connections
  { connection-id: uint }
  {
    elder: principal,
    younger-participant: principal,
    connection-type: (string-utf8 30),
    connection-purpose: (string-utf8 200),
    shared-interests: (list 10 (string-utf8 100)),
    connection-status: (string-utf8 20),
    match-score: uint,
    start-date: uint,
    last-interaction: uint,
    total-sessions: uint,
    planned-sessions: uint,
    session-notes: (optional (string-utf8 500)),
    elder-feedback: (optional (string-utf8 300)),
    participant-feedback: (optional (string-utf8 300)),
    knowledge-areas: (list 8 (string-utf8 100)),
    progress-milestones: (list 5 (string-utf8 150)),
    connection-rating: (optional uint),
    renewal-count: uint,
    completion-status: (string-utf8 20)
  }
)

(define-map sharing-sessions
  { session-id: uint }
  {
    connection-id: uint,
    session-type: (string-utf8 30),
    topic: (string-utf8 150),
    description: (string-utf8 500),
    session-date: uint,
    duration-minutes: uint,
    format: (string-utf8 20),
    location: (optional (string-utf8 100)),
    session-status: (string-utf8 20),
    attendees: (list 10 principal),
    resources-shared: (list 5 (string-utf8 200)),
    key-takeaways: (optional (string-utf8 400)),
    follow-up-actions: (optional (string-utf8 300)),
    session-rating: (optional uint),
    facilitator-notes: (optional (string-utf8 400)),
    artifacts-created: (list 3 (string-utf8 100)),
    next-session-planned: (optional uint)
  }
)

(define-map knowledge-exchange-programs
  { program-id: uint }
  {
    organizer: principal,
    program-name: (string-utf8 150),
    program-type: (string-utf8 50),
    description: (string-utf8 800),
    focus-area: (string-utf8 100),
    target-generations: (list 4 (string-utf8 20)),
    max-participants: uint,
    current-participants: uint,
    enrolled-elders: (list 20 principal),
    enrolled-participants: (list 50 principal),
    program-duration: uint,
    session-frequency: (string-utf8 50),
    program-status: (string-utf8 20),
    start-date: uint,
    completion-date: (optional uint),
    program-rating: uint,
    rating-count: uint,
    cultural-focus: (optional (string-utf8 100)),
    learning-outcomes: (list 8 (string-utf8 200)),
    success-metrics: (list 5 (string-utf8 150))
  }
)

(define-map cultural-bridge-projects
  { project-id: uint }
  {
    lead-elder: principal,
    project-name: (string-utf8 150),
    cultural-tradition: (string-utf8 100),
    description: (string-utf8 600),
    target-audience: (string-utf8 100),
    participating-elders: (list 15 principal),
    learning-participants: (list 30 principal),
    project-type: (string-utf8 40),
    documentation-level: uint,
    preservation-priority: uint,
    project-status: (string-utf8 20),
    start-date: uint,
    target-completion: uint,
    community-impact: uint,
    cultural-artifacts: (list 10 (string-utf8 100)),
    knowledge-transferred: (list 20 (string-utf8 150)),
    project-funding: (optional uint),
    sustainability-plan: (optional (string-utf8 300))
  }
)

(define-map wisdom-circles
  { circle-id: uint }
  {
    circle-keeper: principal,
    circle-name: (string-utf8 100),
    circle-purpose: (string-utf8 300),
    wisdom-theme: (string-utf8 100),
    meeting-schedule: (string-utf8 100),
    circle-members: (list 25 principal),
    elder-guides: (list 8 principal),
    circle-status: (string-utf8 20),
    formation-date: uint,
    total-gatherings: uint,
    wisdom-topics-covered: (list 30 (string-utf8 100)),
    circle-traditions: (list 5 (string-utf8 150)),
    member-contributions: uint,
    circle-rating: uint,
    knowledge-artifacts: (list 15 (string-utf8 100)),
    community-connections: uint,
    circle-legacy: (optional (string-utf8 400))
  }
)

(define-map generational-stories
  { story-id: uint }
  {
    storyteller: principal,
    story-recipient: (optional principal),
    story-title: (string-utf8 200),
    story-category: (string-utf8 50),
    generational-perspective: (string-utf8 30),
    story-content-hash: (optional (string-utf8 64)),
    story-summary: (string-utf8 800),
    historical-context: (optional (string-utf8 300)),
    life-lessons: (list 5 (string-utf8 200)),
    cultural-significance: (string-utf8 300),
    target-generation: (optional (string-utf8 20)),
    sharing-permissions: (string-utf8 20),
    story-impact: uint,
    listener-count: uint,
    story-rating: uint,
    preservation-status: (string-utf8 20),
    creation-date: uint,
    last-shared: uint
  }
)

;; Data Variables
(define-data-var next-connection-id uint u1)
(define-data-var next-session-id uint u1)
(define-data-var next-program-id uint u1)
(define-data-var next-project-id uint u1)
(define-data-var next-circle-id uint u1)
(define-data-var next-story-id uint u1)
(define-data-var total-participants uint u0)
(define-data-var total-connections uint u0)
(define-data-var total-sessions uint u0)
(define-data-var total-programs uint u0)
(define-data-var active-connections uint u0)
(define-data-var community-impact-score uint u0)

;; Private Functions
(define-private (is-valid-generation (generation (string-utf8 20)))
  (or (is-eq generation u"elder")
      (is-eq generation u"senior")
      (is-eq generation u"middle-age")
      (is-eq generation u"young-adult")
      (is-eq generation u"teen")
      (is-eq generation u"child"))
)

(define-private (is-valid-connection-type (connection-type (string-utf8 30)))
  (or (is-eq connection-type u"mentorship")
      (is-eq connection-type u"story-sharing")
      (is-eq connection-type u"skill-transfer")
      (is-eq connection-type u"cultural-bridge")
      (is-eq connection-type u"wisdom-exchange")
      (is-eq connection-type u"family-history")
      (is-eq connection-type u"career-guidance")
      (is-eq connection-type u"life-lessons")
      (is-eq connection-type u"hobby-sharing"))
)

(define-private (is-valid-connection-status (status (string-utf8 20)))
  (or (is-eq status u"pending")
      (is-eq status u"active")
      (is-eq status u"paused")
      (is-eq status u"completed")
      (is-eq status u"ended")
      (is-eq status u"renewed"))
)

(define-private (calculate-match-score (elder principal) (participant principal))
  ;; Simplified match scoring based on shared interests and compatibility
  (let
    (
      (elder-info (unwrap-panic (map-get? generation-participants { participant: elder })))
      (participant-info (unwrap-panic (map-get? generation-participants { participant: participant })))
    )
    ;; Basic scoring algorithm - in practice would be more sophisticated
    (+ (* (len (get skills-to-share elder-info)) u5)
       (* (len (get skills-to-learn participant-info)) u3)
       (* (get community-rating elder-info) u2))
  )
)

;; Public Functions
(define-public (register-participant
    (name (string-utf8 100))
    (generation (string-utf8 20))
    (age-range (string-utf8 20))
    (bio (string-utf8 1000))
    (interests (list 10 (string-utf8 100)))
    (skills-to-share (list 15 (string-utf8 100)))
    (skills-to-learn (list 15 (string-utf8 100)))
    (cultural-background (string-utf8 200))
    (languages (list 5 (string-utf8 50)))
    (availability (string-utf8 200))
    (connection-preference (string-utf8 50))
  )
  (begin
    (asserts! (is-none (map-get? generation-participants { participant: tx-sender })) (err u311))
    (asserts! (is-valid-generation generation) err-invalid-generation)
    
    (map-set generation-participants
      { participant: tx-sender }
      {
        name: name,
        generation: generation,
        age-range: age-range,
        bio: bio,
        interests: interests,
        skills-to-share: skills-to-share,
        skills-to-learn: skills-to-learn,
        cultural-background: cultural-background,
        languages: languages,
        availability: availability,
        connection-preference: connection-preference,
        total-connections: u0,
        active-connections: u0,
        mentoring-hours: u0,
        community-rating: u0,
        total-ratings: u0,
        registration-date: block-height,
        last-active: block-height,
        verified-elder: (or (is-eq generation u"elder") (is-eq generation u"senior")),
        mentor-status: u"available"
      }
    )
    
    (var-set total-participants (+ (var-get total-participants) u1))
    (ok true)
  )
)

(define-public (create-intergenerational-connection
    (elder principal)
    (younger-participant principal)
    (connection-type (string-utf8 30))
    (connection-purpose (string-utf8 200))
    (shared-interests (list 10 (string-utf8 100)))
    (knowledge-areas (list 8 (string-utf8 100)))
    (planned-sessions uint)
  )
  (let
    (
      (connection-id (var-get next-connection-id))
      (elder-info (unwrap! (map-get? generation-participants { participant: elder }) err-participant-not-found))
      (participant-info (unwrap! (map-get? generation-participants { participant: younger-participant }) err-participant-not-found))
      (match-score (calculate-match-score elder younger-participant))
    )
    (asserts! (is-valid-connection-type connection-type) err-invalid-connection-type)
    (asserts! (get verified-elder elder-info) (err u312))
    (asserts! (not (is-eq (get generation elder-info) (get generation participant-info))) (err u313))
    
    ;; Create connection
    (map-set intergenerational-connections
      { connection-id: connection-id }
      {
        elder: elder,
        younger-participant: younger-participant,
        connection-type: connection-type,
        connection-purpose: connection-purpose,
        shared-interests: shared-interests,
        connection-status: u"pending",
        match-score: match-score,
        start-date: block-height,
        last-interaction: block-height,
        total-sessions: u0,
        planned-sessions: planned-sessions,
        session-notes: none,
        elder-feedback: none,
        participant-feedback: none,
        knowledge-areas: knowledge-areas,
        progress-milestones: (list),
        connection-rating: none,
        renewal-count: u0,
        completion-status: u"in-progress"
      }
    )
    
    ;; Update participant connection counts
    (map-set generation-participants
      { participant: elder }
      (merge elder-info {
        total-connections: (+ (get total-connections elder-info) u1),
        last-active: block-height
      })
    )
    
    (map-set generation-participants
      { participant: younger-participant }
      (merge participant-info {
        total-connections: (+ (get total-connections participant-info) u1),
        last-active: block-height
      })
    )
    
    (var-set next-connection-id (+ connection-id u1))
    (var-set total-connections (+ (var-get total-connections) u1))
    
    (ok connection-id)
  )
)

(define-public (activate-connection (connection-id uint))
  (let
    (
      (connection (unwrap! (map-get? intergenerational-connections { connection-id: connection-id }) err-connection-not-found))
    )
    (asserts! (or (is-eq tx-sender (get elder connection))
                  (is-eq tx-sender (get younger-participant connection))) err-unauthorized)
    (asserts! (is-eq (get connection-status connection) u"pending") err-invalid-status)
    
    ;; Activate connection
    (map-set intergenerational-connections
      { connection-id: connection-id }
      (merge connection {
        connection-status: u"active",
        start-date: block-height
      })
    )
    
    ;; Update active connections count
    (var-set active-connections (+ (var-get active-connections) u1))
    
    (ok true)
  )
)

(define-public (create-sharing-session
    (connection-id uint)
    (session-type (string-utf8 30))
    (topic (string-utf8 150))
    (description (string-utf8 500))
    (duration-minutes uint)
    (format (string-utf8 20))
    (location (optional (string-utf8 100)))
  )
  (let
    (
      (session-id (var-get next-session-id))
      (connection (unwrap! (map-get? intergenerational-connections { connection-id: connection-id }) err-connection-not-found))
    )
    (asserts! (or (is-eq tx-sender (get elder connection))
                  (is-eq tx-sender (get younger-participant connection))) err-unauthorized)
    (asserts! (is-eq (get connection-status connection) u"active") err-invalid-status)
    
    ;; Create session
    (map-set sharing-sessions
      { session-id: session-id }
      {
        connection-id: connection-id,
        session-type: session-type,
        topic: topic,
        description: description,
        session-date: block-height,
        duration-minutes: duration-minutes,
        format: format,
        location: location,
        session-status: u"scheduled",
        attendees: (list (get elder connection) (get younger-participant connection)),
        resources-shared: (list),
        key-takeaways: none,
        follow-up-actions: none,
        session-rating: none,
        facilitator-notes: none,
        artifacts-created: (list),
        next-session-planned: none
      }
    )
    
    ;; Update connection session count
    (map-set intergenerational-connections
      { connection-id: connection-id }
      (merge connection {
        total-sessions: (+ (get total-sessions connection) u1),
        last-interaction: block-height
      })
    )
    
    (var-set next-session-id (+ session-id u1))
    (var-set total-sessions (+ (var-get total-sessions) u1))
    
    (ok session-id)
  )
)

(define-public (complete-session
    (session-id uint)
    (key-takeaways (string-utf8 400))
    (session-rating uint)
    (follow-up-actions (optional (string-utf8 300)))
    (artifacts-created (list 3 (string-utf8 100)))
  )
  (let
    (
      (session (unwrap! (map-get? sharing-sessions { session-id: session-id }) err-session-not-found))
      (connection (unwrap! (map-get? intergenerational-connections { connection-id: (get connection-id session) }) err-connection-not-found))
    )
    (asserts! (or (is-eq tx-sender (get elder connection))
                  (is-eq tx-sender (get younger-participant connection))) err-unauthorized)
    (asserts! (and (>= session-rating u1) (<= session-rating u5)) (err u314))
    
    ;; Update session completion
    (map-set sharing-sessions
      { session-id: session-id }
      (merge session {
        session-status: u"completed",
        key-takeaways: (some key-takeaways),
        session-rating: (some session-rating),
        follow-up-actions: follow-up-actions,
        artifacts-created: artifacts-created
      })
    )
    
    ;; Update connection last interaction
    (map-set intergenerational-connections
      { connection-id: (get connection-id session) }
      (merge connection { last-interaction: block-height })
    )
    
    ;; Update community impact score
    (var-set community-impact-score (+ (var-get community-impact-score) session-rating))
    
    (ok true)
  )
)

(define-public (create-knowledge-exchange-program
    (program-name (string-utf8 150))
    (program-type (string-utf8 50))
    (description (string-utf8 800))
    (focus-area (string-utf8 100))
    (target-generations (list 4 (string-utf8 20)))
    (max-participants uint)
    (program-duration uint)
    (session-frequency (string-utf8 50))
    (learning-outcomes (list 8 (string-utf8 200)))
  )
  (let
    (
      (program-id (var-get next-program-id))
      (organizer-info (unwrap! (map-get? generation-participants { participant: tx-sender }) err-participant-not-found))
    )
    (asserts! (>= (get community-rating organizer-info) u3) err-insufficient-reputation)
    
    (map-set knowledge-exchange-programs
      { program-id: program-id }
      {
        organizer: tx-sender,
        program-name: program-name,
        program-type: program-type,
        description: description,
        focus-area: focus-area,
        target-generations: target-generations,
        max-participants: max-participants,
        current-participants: u0,
        enrolled-elders: (list),
        enrolled-participants: (list),
        program-duration: program-duration,
        session-frequency: session-frequency,
        program-status: u"open",
        start-date: u0,
        completion-date: none,
        program-rating: u0,
        rating-count: u0,
        cultural-focus: none,
        learning-outcomes: learning-outcomes,
        success-metrics: (list)
      }
    )
    
    (var-set next-program-id (+ program-id u1))
    (var-set total-programs (+ (var-get total-programs) u1))
    
    (ok program-id)
  )
)

(define-public (create-wisdom-circle
    (circle-name (string-utf8 100))
    (circle-purpose (string-utf8 300))
    (wisdom-theme (string-utf8 100))
    (meeting-schedule (string-utf8 100))
  )
  (let
    (
      (circle-id (var-get next-circle-id))
      (keeper-info (unwrap! (map-get? generation-participants { participant: tx-sender }) err-participant-not-found))
    )
    (asserts! (get verified-elder keeper-info) (err u315))
    
    (map-set wisdom-circles
      { circle-id: circle-id }
      {
        circle-keeper: tx-sender,
        circle-name: circle-name,
        circle-purpose: circle-purpose,
        wisdom-theme: wisdom-theme,
        meeting-schedule: meeting-schedule,
        circle-members: (list tx-sender),
        elder-guides: (list tx-sender),
        circle-status: u"forming",
        formation-date: block-height,
        total-gatherings: u0,
        wisdom-topics-covered: (list),
        circle-traditions: (list),
        member-contributions: u0,
        circle-rating: u0,
        knowledge-artifacts: (list),
        community-connections: u0,
        circle-legacy: none
      }
    )
    
    (var-set next-circle-id (+ circle-id u1))
    (ok circle-id)
  )
)

(define-public (share-generational-story
    (story-title (string-utf8 200))
    (story-category (string-utf8 50))
    (generational-perspective (string-utf8 30))
    (story-summary (string-utf8 800))
    (historical-context (optional (string-utf8 300)))
    (life-lessons (list 5 (string-utf8 200)))
    (cultural-significance (string-utf8 300))
    (target-generation (optional (string-utf8 20)))
    (sharing-permissions (string-utf8 20))
  )
  (let
    (
      (story-id (var-get next-story-id))
      (storyteller-info (unwrap! (map-get? generation-participants { participant: tx-sender }) err-participant-not-found))
    )
    (map-set generational-stories
      { story-id: story-id }
      {
        storyteller: tx-sender,
        story-recipient: none,
        story-title: story-title,
        story-category: story-category,
        generational-perspective: generational-perspective,
        story-content-hash: none,
        story-summary: story-summary,
        historical-context: historical-context,
        life-lessons: life-lessons,
        cultural-significance: cultural-significance,
        target-generation: target-generation,
        sharing-permissions: sharing-permissions,
        story-impact: u0,
        listener-count: u0,
        story-rating: u0,
        preservation-status: u"active",
        creation-date: block-height,
        last-shared: block-height
      }
    )
    
    (var-set next-story-id (+ story-id u1))
    (ok story-id)
  )
)

;; Read Functions
(define-read-only (get-participant (participant principal))
  (map-get? generation-participants { participant: participant })
)

(define-read-only (get-connection (connection-id uint))
  (map-get? intergenerational-connections { connection-id: connection-id })
)

(define-read-only (get-sharing-session (session-id uint))
  (map-get? sharing-sessions { session-id: session-id })
)

(define-read-only (get-exchange-program (program-id uint))
  (map-get? knowledge-exchange-programs { program-id: program-id })
)

(define-read-only (get-wisdom-circle (circle-id uint))
  (map-get? wisdom-circles { circle-id: circle-id })
)

(define-read-only (get-generational-story (story-id uint))
  (map-get? generational-stories { story-id: story-id })
)

(define-read-only (get-sharing-stats)
  {
    total-participants: (var-get total-participants),
    total-connections: (var-get total-connections),
    active-connections: (var-get active-connections),
    total-sessions: (var-get total-sessions),
    total-programs: (var-get total-programs),
    community-impact-score: (var-get community-impact-score),
    next-connection-id: (var-get next-connection-id),
    next-session-id: (var-get next-session-id),
    next-program-id: (var-get next-program-id),
    next-circle-id: (var-get next-circle-id),
    next-story-id: (var-get next-story-id)
  }
)

