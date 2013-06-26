require 'spec_helper'

describe BotsController do
  describe "GET index" do
    it 'populates an array of Bots' do
      bots = create_list(:bot, 2)
      get 'index'
      response.should be_success
      assigns(:bots).should eq(bots)
    end

    it 'includes a list of Skill Levels' do
      skill_levels = create_list(:skill_level, 2)
      get 'index'
      assigns(:skill_levels).should eq(skill_levels)
    end

    context 'without an authenticated User' do
      it 'does not include a new Bot' do
        get 'index'
        assigns(:bot).should be_nil
      end
    end

    context 'with an authenticated User' do
      before(:each) do
        @user = create(:user)
        sign_in @user
      end

      it 'includes a new Bot' do
        get 'index'
        assigns(:bot).should be_a(Bot)
        assigns(:bot).should be_new_record
      end

    end
  end

  describe 'GET show' do
    before(:each) do
      @bot = create(:bot)
    end

    it 'assigns the requested Bot to @bot' do
      get :show, :id => @bot
      assigns(:bot).should eq(@bot)
    end

    it 'renders the show view' do
      get :show, :id => @bot
      response.should render_template :show
    end
  end

  describe 'POST create' do
    context 'without an authenticated User' do
      it 'redirects to login' do
        post :create
        response.should redirect_to(new_user_session_path)
      end
    end

    context 'with an authenticated User' do
      before(:each) do
        @user = create(:user)
        sign_in @user
      end

      context 'with invalid parameters' do
        it 'does not save the new Bot' do
          expect { post :create, attributes_for(:invalid_bot) }.to_not change(Bot, :count)
        end

        it 'renders the index action' do
          post :create, attributes_for(:invalid_bot)
          response.should render_template :index
        end
      end

      context 'with valid parameters' do
        before(:each) do
          @attrs = attributes_for(:new_bot, :user => @user, :category_ids => [create(:category).id])
        end

        it 'creates a new Bot' do
          expect { post :create, :bot => @attrs }.to change(Bot, :count).by(1)
        end

        it 'redirects to the bots_path' do
          post :create, :bot => @attrs
          response.should redirect_to(bots_path)
        end
      end
    end
  end
end
