class Question < ApplicationRecord
  belongs_to :section

  #Estos los tipos de questions que tendra el atributo questions_type
  enum question_type: [:default, :text_free, :multiple, :level]
end
