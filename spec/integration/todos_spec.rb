require 'swagger_helper'

describe 'Todos API' do
  # POST /signup endpoint
  path '/signup' do
    post 'Signup a new user' do
      tags 'Auth'
      consumes 'application/json'
      parameter name: :name, in: :body, schema: { type: :string }
      parameter name: :email, in: :body, schema: { type: :string }
      parameter name: :password, in: :body, schema: { type: :string }
      parameter name: :password_confirmation, in: :body, schema: { type: :string }

      response '201', 'user created' do
        let(:name) { 'John Doe' }
        let(:email) { 'john@example.com' }
        let(:password) { 'password' }
        let(:password_confirmation) { 'password' }
        run_test!
      end

      response '422', 'invalid parameters' do
        let(:name) { '' }
        let(:email) { 'invalid' }
        let(:password) { 'short' }
        let(:password_confirmation) { 'mismatch' }
        run_test!
      end
    end
  end

  # POST /auth/login endpoint
  path '/auth/login' do
    post 'Login a user' do
      tags 'Auth'
      consumes 'application/json'
      parameter name: :email, in: :body, schema: { type: :string }
      parameter name: :password, in: :body, schema: { type: :string }

      response '200', 'user logged in' do
        let(:email) { 'john@example.com' }
        let(:password) { 'password' }
        run_test!
      end

      response '401', 'invalid credentials' do
        let(:email) { 'wrong@example.com' }
        let(:password) { 'wrongpassword' }
        run_test!
      end
    end
  end

  # GET /auth/logout endpoint
  path '/auth/logout' do
    get 'Logout the user' do
      tags 'Auth'
      response '204', 'logout successful' do
        run_test!
      end
    end
  end

  # GET and POST /todos endpoints
  path '/todos' do
    get 'List all todos' do
      tags 'Todos'
      response '200', 'todos found' do
        run_test!
      end
    end

    post 'Create a new todo' do
      tags 'Todos'
      consumes 'application/json'
      parameter name: :title, in: :body, schema: { type: :string }
      parameter name: :created_by, in: :body, schema: { type: :integer }

      response '201', 'todo created' do
        let(:title) { 'New Todo' }
        let(:created_by) { 1 }
        run_test!
      end

      response '422', 'validation failed' do
        let(:title) { nil }
        let(:created_by) { nil }
        run_test!
      end
    end
  end

  # /todos/{id} endpoint (GET, PUT, DELETE)
  path '/todos/{id}' do
    get 'Get a todo' do
      tags 'Todos'
      parameter name: :id, in: :path, type: :string

      response '200', 'todo found' do
        let(:id) { Todo.create(title: 'Test Todo', created_by: 1).id }
        run_test!
      end

      response '404', 'todo not found' do
        let(:id) { 'non-existing-id' }
        run_test!
      end
    end

    put 'Update a todo' do
      tags 'Todos'
      parameter name: :id, in: :path, type: :string
      parameter name: :title, in: :body, schema: { type: :string }
      parameter name: :created_by, in: :body, schema: { type: :integer }

      response '200', 'todo updated' do
        let(:id) { Todo.create(title: 'Test Todo', created_by: 1).id }
        let(:title) { 'Updated Todo' }
        let(:created_by) { 1 }
        run_test!
      end

      response '404', 'todo not found' do
        let(:id) { 'non-existing-id' }
        let(:title) { 'Updated Todo' }
        let(:created_by) { 1 }
        run_test!
      end
    end

    delete 'Delete a todo' do
      tags 'Todos'
      parameter name: :id, in: :path, type: :string

      response '204', 'todo deleted' do
        let(:id) { Todo.create(title: 'Test Todo', created_by: 1).id }
        run_test!
      end

      response '404', 'todo not found' do
        let(:id) { 'non-existing-id' }
        run_test!
      end
    end
  end

  # /todos/{id}/items/{iid} endpoint (GET)
  path '/todos/{id}/items/{iid}' do
    get 'Get a todo item' do
      tags 'Todos'
      parameter name: :id, in: :path, type: :string
      parameter name: :iid, in: :path, type: :string

      response '200', 'todo item found' do
        let(:id) { Todo.create(title: 'Test Todo', created_by: 1).id }
        let(:iid) { 1 }
        run_test!
      end

      response '404', 'todo item not found' do
        let(:id) { 'non-existing-id' }
        let(:iid) { 'non-existing-item-id' }
        run_test!
      end
    end
  end

  # POST /todos/{id}/items endpoint (POST)
  path '/todos/{id}/items' do
    post 'Create a new todo item' do
      tags 'Todos'
      consumes 'application/json'
      parameter name: :description, in: :body, schema: { type: :string }
      parameter name: :completed, in: :body, schema: { type: :boolean }

      response '201', 'todo item created' do
        let(:description) { 'Test Item' }
        let(:completed) { false }
        run_test!
      end

      response '422', 'validation failed' do
        let(:description) { nil }
        let(:completed) { false }
        run_test!
      end
    end
  end

  # /todos/{id}/items/{iid} endpoint (PUT, DELETE)
  path '/todos/{id}/items/{iid}' do
    put 'Update a todo item' do
      tags 'Todos'
      parameter name: :id, in: :path, type: :string
      parameter name: :iid, in: :path, type: :string
      parameter name: :description, in: :body, schema: { type: :string }
      parameter name: :completed, in: :body, schema: { type: :boolean }

      response '200', 'todo item updated' do
        let(:id) { Todo.create(title: 'Test Todo', created_by: 1).id }
        let(:iid) { 1 }
        let(:description) { 'Updated Item' }
        let(:completed) { true }
        run_test!
      end

      response '404', 'todo item not found' do
        let(:id) { 'non-existing-id' }
        let(:iid) { 'non-existing-item-id' }
        run_test!
      end
    end

    delete 'Delete a todo item' do
      tags 'Todos'
      parameter name: :id, in: :path, type: :string
      parameter name: :iid, in: :path, type: :string

      response '204', 'todo item deleted' do
        let(:id) { Todo.create(title: 'Test Todo', created_by: 1).id }
        let(:iid) { 1 }
        run_test!
      end

      response '404', 'todo item not found' do
        let(:id) { 'non-existing-id' }
        let(:iid) { 'non-existing-item-id' }
        run_test!
      end
    end
  end
end