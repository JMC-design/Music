(in-package :music)

;; TODO
;;   make environments have Parents, and able to shadow each others values
;;   possibly also give environments Content.. that or create a musical Closure object or someting..

(defclass environment ()
  ((key
    :initarg  :key
    :initform (key 'c-major)
    :type     key
    :accessor key)
   (reference
    :initarg  :reference
    :initform (note 'c4)
    :type     note
    :accessor reference)
   (harmony
    :initarg  :harmony
    :initform nil
    :type     list
    :accessor harmony)
   (tempo
    :initarg  :tempo
    :initform (make-tempo 120)
    :type     tempo
    :accessor tempo)
   (meter
    :initarg  :meter
    :initform (make-meter 4 4)
    :type     meter
    :accessor meter))
  (:documentation "A musical environment in which musical objects are performed."))

(defclass container ()
  ((objects
    :initarg  :objects
    :initform nil
    :type     list
    :accessor objects)
   (accents
    :initarg  :accents
    :initform nil
    :type     list
    :accessor accents))
  (:documentation "An musical object containing other musical objects."))

(defclass chord (container) ()
  (:documentation "A vertical sequence of musical objects."))

(defclass seq (container)
  ((beats
    :initarg  :beats
    :initform nil
    :type     list
    :accessor beats))
  (:documentation "A horizontal sequence of musical objects."))

(defun chord (objects &optional accents)
  "Make a chord from a list of musical objects."
  (make-instance
   'chord
   :objects objects
   :accents (or accents (make-list (length objects) :initial-element 1))))

(defun seq (objects &optional beats accents)
  "Make a sequence from a list of musical objects."
  (make-instance
   'seq
   :objects objects
   :beats   (or beats (make-list (length objects) :initial-element 1))
   :accents (or accents (make-list (length objects) :initial-element 1))))

(defmacro v (&rest objects)
  "Make a chord."
  `(chord ',objects))

(defmacro h (&rest objects)
  "Make a sequence."
  `(seq ',objects))

(defvar *global-environment* (make-instance 'environment))

(defun default-environment ()
  "Return a default musical environment."
  *global-environment*)

(defmethod clone ((env environment))
  "Clone a musical environment."
  (make-instance
   'environment
   :key       (key env)
   :reference (reference env)
   :harmony   (harmony env)
   :tempo     (tempo env)
   :meter     (meter env)))

(defmethod reference ((list list))
  "Return the relevant reference note from a list of notes."
  (reference (car (last list))))

(defmethod reference ((note note))
  "Return a note as its own reference."
  note)
