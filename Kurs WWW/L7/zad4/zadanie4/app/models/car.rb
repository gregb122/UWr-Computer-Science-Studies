class Car < ApplicationRecord
    validates_presence_of :reg_number
    validates_presence_of :production_year
    validates_presence_of :date_of_first_registration
    validates_presence_of :car_brand
    validates_presence_of :fuel_category

    validates_format_of :production_year, 
    with: /\A[0-9]+\z/, on: :create, message: "regexp error"

    validates_format_of :date_of_first_registration, 
    with: /\A(0[1-9]|1[0-9]|2[0-9]|3[01]).(0[1-9]|1[012]).[0-9]{4}\z/, on: :create, message: "regexp error"

    validates_format_of :car_brand, 
    with: /\A[a-zA-Z]+\z/ ,on: :create, message: "regexp error"
    
    validates_format_of :fuel_category, 
    with: /\AP|ON|LPG|EE\z/, on: :create, message: "regexp error"
    
    validates_format_of :reg_number, 
    with: /\A[a-zA-Z]{2,3}[0-9]{4,6}\z/ , on: :create, message: "regexp error"
end
