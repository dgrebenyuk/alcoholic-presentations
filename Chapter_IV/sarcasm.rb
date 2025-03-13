# frozen_string_literal: true

require 'json'
require 'pycall'
require 'pry'

class SarcasmDetector
  TRAINING_SIZE = 140 # 70% for training
  VALIDATE_SIZE = 40 # 20% for validating
  TESTING_SIZE = 20 # 10% for testing
  VOCABULARY_SIZE = 10_000
  OOV_TOKEN = '<OOV>'
  EPOCHS = 50
  MAX_LENGTH = 10
  PADDING = 'post'
  TRUNCATING = 'pre'
  EMBEDDING_DIM = 64

  attr_reader :tf, :np, :plt, :tf_text, :tf_seq, # Readers for Python modules
              :sentences, :labels, # Datastore
              :training_padded, :training_labels,
              :validating_padded, :validating_labels,
              :model

  def initialize
    @tf = PyCall.import_module('tensorflow')
    @np = PyCall.import_module('numpy')
    @plt = PyCall.import_module('matplotlib.pyplot')
    @tf_text = PyCall.import_module('tensorflow.keras.preprocessing.text')
    @tf_seq = PyCall.import_module('tensorflow.keras.preprocessing.sequence')

    @sentences = []
    @labels = []

    load_datastore
    build_model
  end

  def testing
    testing_sentences = sentences.last(TESTING_SIZE)
    testing_labels = np.array(labels.last(TESTING_SIZE))

    testing_sequences = tokenizer.texts_to_sequences(testing_sentences)
    testing_padded = tf_seq.pad_sequences(
      testing_sequences,
      maxlen: MAX_LENGTH,
      padding: PADDING,
      truncating: TRUNCATING
    )

    metrics = model.test_on_batch(testing_padded, testing_labels, nil, true)
    puts ''
    metrics.to_h.each do |metric, value|
      puts "#{metric} : #{value.to_f.round(2) * 100}%"
    end
    puts ''
  end

  def is_sarcastic?(titles)
    # [
    #   'The Future of Artificial Intelligence in Healthcare: Opportunities and Challenges',
    #   'Strategies for Effective Remote Team Management in a Post-Pandemic World',
    #   "How to be the Perfect 'YES' Person: Say Goodbye to Free Time and Sanity!"
    # ]
    titles = [titles] unless titles.is_a? Array
    # Convert sentences to sequences
    sequences = tokenizer.texts_to_sequences(titles.map(&:downcase))

    # Pad the sequences
    padded = tf_seq.pad_sequences(
      sequences,
      maxlen: MAX_LENGTH,
      padding: PADDING,
      truncating: TRUNCATING
    )

    # Convert padded to a NumPy array
    padded_np = np.array(padded.tolist)

    # Make predictions
    predictions = model.predict(padded_np)
    results = predictions.tolist.to_a.flatten.map do |res|
      (res * 100).round(2)
    end

    titles.each_with_index do |title, index|
      puts ''
      print title
      print ' -> '
      puts "#{results[index]}%"
      puts ''
    end
  end

  private

  def load_datastore
    file_path = './titles.json'
    datastore = JSON.parse(File.read(file_path))

    datastore.each do |item|
      sentences << item['headline']
      labels << item['is_sarcastic']
    end
  end

  def build_model
    prepare_training_data
    prepare_validating_data

    @model = tf.keras.Sequential.call(
      [
        tf.keras.layers.Embedding.call(VOCABULARY_SIZE, EMBEDDING_DIM),
        tf.keras.layers.GlobalAveragePooling1D.new,
        tf.keras.layers.Dense.call(24, activation: 'relu'),
        tf.keras.layers.Dense.call(1, activation: 'sigmoid')
      ]
    )

    model.compile(loss: 'binary_crossentropy', optimizer: 'adam', metrics: ['accuracy'])

    model.fit(
      training_padded,
      training_labels,
      epochs: EPOCHS,
      validation_data: [validating_padded, validating_labels],
      verbose: 2
    )
  end

  def prepare_training_data
    training_sentences = sentences[0, TRAINING_SIZE]
    @training_labels = np.array(labels[0, TRAINING_SIZE])

    tokenizer.fit_on_texts(training_sentences)
    tokenizer.word_index

    training_sequences = tokenizer.texts_to_sequences(training_sentences)
    @training_padded = tf_seq.pad_sequences(
      training_sequences,
      maxlen: MAX_LENGTH,
      padding: PADDING,
      truncating: TRUNCATING
    )
  end

  def prepare_validating_data
    validating_sentences = sentences[TRAINING_SIZE, VALIDATE_SIZE]
    @validating_labels = np.array(labels[TRAINING_SIZE, VALIDATE_SIZE])

    validating_sequences = tokenizer.texts_to_sequences(validating_sentences)
    @validating_padded = tf_seq.pad_sequences(
      validating_sequences,
      maxlen: MAX_LENGTH,
      padding: PADDING,
      truncating: TRUNCATING
    )
  end

  def tokenizer
    @tokenizer ||= tf_text.Tokenizer.new(num_words: VOCABULARY_SIZE, oov_token: OOV_TOKEN)
  end
end
