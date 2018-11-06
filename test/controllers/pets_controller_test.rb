require 'test_helper'

class PetsControllerTest < ActionDispatch::IntegrationTest
  # describe PetsController do
  #end

  #default expected status to sucess
  def check_response(expected_type:, expected_status: :success)
    must_respond_with expected_status
    expect(response.header['Content-Type']).must_include 'json'

    body = JSON.parse(response.body)
    expect(body).must_be_kind_of expected_type
    return body
  end
  describe "index" do
    PET_FIELDS = %w(id name age human).sort


    # These tests are a little verbose - yours do not need to be
    # this explicit.

    #One test for each behavior you're interested in
    #arrange step different - different test
    #act step different - different describe block
    #assert test just follows act
    #Be more explicit in test for API
    #JSON returns as string
    it "is a real working route" do
      get pets_path
      # must_respond_with :success
      # expect(response.header['Content-Type']).must_include 'json'
      #
      # body = JSON.parse(response.body)
      # expect(body).must_be_kind_of Array

      body = check_response(expected_type: Array)

      expect(body.length).must_equal Pet.count
      body.each do |pet|
        expect(pet.keys.sort).must_equal PET_FIELDS
      end
    end

    it 'returns an empty array when there are no pets' do
      #destroy all pets
      Pet.destroy_all

      get pets_path

      body = check_response(expected_type: Array)
      expect(body).must_equal []
    end
  end

  describe 'show' do
    it "retrieves info on a pet" do

      pet = pets(:one)
      get pet_path(pet.id)
      # must_respond_with :success
      #
      # body = JSON.parse(response.body)
      # expect(body).must_be_kind_of Hash
      # expect(body["id"]).must_equal pet.id
      # expect(body["name"]).must_equal pet.name
      # expect(body["age"]).must_equal pet.age
      # expect(body["human"]).must_equal pet.human

      body = check_response(expected_type: Hash)
      expect(body.keys.sort).must_equal PET_FIELDS
    end

    it "does something when pet DNE" do
      pet = Pet.first.destroy
      expect(get pet_path(pet))
      # must_respond_with :not_found
      #
      # body = JSON.parse(response.body)
      body = check_response(expected_type: Hash, expected_status: :not_found)
      expect(body.keys).must_include "errors"
    end
  end

  describe "create" do
    let(:pet_data) {
      {
        name: "Hammy",
        age: 10,
        human: "Chantelle"
      }
    }

    it 'creates a new pet given valid data' do
      expect {
        post pets_path, params: { pet: pet_data }
      }.must_change "Pet.count", 1

      body = check_response(expected_type: Hash)

      # body = JSON.parse(response.body)

      # expect(body.keys).must_equal ["id"]
      expect(Pet.last.id).must_equal body["id"]

      # expect(Pet.last.name).must_equal pet_data[:name]
      # expect(Pet.last.age).must_equal  pet_data[:age]
      # expect(Pet.last.human).must_equal  pet_data[:human]
    end
    
    it 'returns an error for invalid pet data' do
      pet_data["name"] = nil
      expect {
        post pets_path, params: { pet: pet_data }
      }.wont_change "Pet.count"

      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body).must_include "errors"
      expect(body["errors"]).must_include "name"
    end
  end

end
