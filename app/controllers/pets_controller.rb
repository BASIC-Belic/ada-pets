class PetsController < ApplicationController

  #Most common codes
  #http://billpatrianakos.me/blog/2013/10/13/list-of-rails-status-code-symbols/
  # 200 - :ok
  # 204 - :no_content
  # 400 - :bad_request
  # 401 - :unauthorized
  # 403 - :forbidden
  # 404 - :not_found
  # 500 - :internal_server_error

  def index
    pets = Pet.all
    # render json: { example_key: "value"}
    # rails knows how to turn collection of model instances into json
    # dont need instance var bc not sending to a view
    # render json: pets
    # render json: pets.as_json(except: [:created_at, :updated_at])
    # rails defaults to 200OK if some JSON returned, but be explicit
    if pets
      # render json: pets.as_json(only: [:id, :name, :age, :human]), status: :ok
      render json: jsonify(pets), status: :ok
    else
      #something else, status: :not_found
    end
  end

  def show
    # get pets?id=""
    pet = Pet.find_by(id: params[:id])
    if pet
      # render json: pet.as_json(only: [:id, :name, :age, :human]), status: :ok
      render json: jsonify(pet), status: :ok
      # head :not_found
      # render json {}, status: :not_found
      # render json {errors: {pet_id: ["No such pet"]}}, status: :not_found

      # render json {errors: {pet_id: ["No such pet"]}}, status: :not_found
    end
  end

  #courtesy to your user to assign id so user can find it
  #attach data to body, form data, so keys and values
  #POSTMAN (RAW BODY):
  #Click Application JSON, not text
  # {
  #   "pet": {
  #     "name": "hammy",
  #     "age": 22,
  #     "human": "chantelle"
  #   }
  # }

  def create
    pet = Pet.new(pet_params)
    if pet.save
      render json: { id: pet.id }
    else
      render_errors(:bad_request, pet.errors.messages)
    end
  end

  private

  def jsonify(pet_data)
    return pet_data.as_json(only: [:id, :name, :age, :human])
  end

  def pet_params
    params.require(:pet).permit(:name, :age, :human)
  end
end
