require "spec_helper"

["status", "material", "tool"].each do |klass|
  describe "#{klass.classify.pluralize}Controller".constantize do
    disconnect_sunspot
    let(:user1){FactoryGirl.create :user}
    let(:user2){FactoryGirl.create :user}
    let(:recipe1){FactoryGirl.create :recipe, user_id: user1.id}
    let("#{klass}1"){FactoryGirl.create "#{klass}", recipe_id: recipe1.id}
    let(:valid_attributes){FactoryGirl.build(klass).attributes}

    describe "POST create" do
      context "with owner" do
        before do
          controller.stub(:current_user).and_return user1
          post :create, user_id: user1.id, recipe_id: recipe1.id,
            klass => valid_attributes, format: :json
        end
        it_behaves_like "success"
      end
      context "with non owner" do
        before do
          controller.stub(:current_user).and_return user2
          post :create, user_id: user1.id, recipe_id: recipe1.id,
            klass => valid_attributes, format: :json
        end
        it_behaves_like "unauthorized"
      end
    end

    describe "PATCH update" do
      context "with owner" do
        before do
          controller.stub(:current_user).and_return user1
          patch :update, user_id: user1.id, recipe_id: recipe1.id,
            id: send("#{klass}1").id, klass => valid_attributes, format: :json
        end
        it_behaves_like "success"
      end
      context "with non owner" do
        before do
          controller.stub(:current_user).and_return user2
          patch :update, user_id: user1.id, recipe_id: recipe1.id,
            id: send("#{klass}1").id, klass => valid_attributes, format: :json
        end
        it_behaves_like "unauthorized"
      end
    end

    describe "DELETE destroy" do
      context "with owner" do
        before do
          controller.stub(:current_user).and_return user1
          delete :destroy, user_id: user1.id, recipe_id: recipe1.id,
            id: send("#{klass}1").id, format: :json
        end
        it_behaves_like "success"
      end
      context "with non owner" do
        before do
          controller.stub(:current_user).and_return user2
          delete :destroy, user_id: user1.id, recipe_id: recipe1.id,
            id: send("#{klass}1").id, format: :json
        end
        it_behaves_like "unauthorized"
      end
    end
  end
end
