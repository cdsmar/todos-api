require 'swagger_helper'

describe 'API V1' do

  # =========================
  # AUTH
  # =========================

  path '/signup' do
    post 'Signup a new user' do
      tags 'Auth'
      consumes 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string }
        },
        required: ['name', 'email', 'password', 'password_confirmation'],
        example: {
          name: 'Sophia Brown',
          email: 'sophia@gmail.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }

      response '201', 'user created' do
        let(:user) do
          {
            name: 'Sophia Brown',
            email: 'sophia@gmail.com',
            password: 'password123',
            password_confirmation: 'password123'
          }
        end
        run_test!
      end

      response '422', 'invalid parameters' do
        let(:user) do
          {
            name: '',
            email: 'invalid',
            password: '123',
            password_confirmation: 'wrong'
          }
        end
        run_test!
      end
    end
  end


  path '/auth/login' do
    post 'Login a user' do
      tags 'Auth'
      consumes 'application/json'

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: ['email', 'password'],
        example: {
          email: 'sophia@gmail.com',
          password: 'password123'
        }
      }

      response '200', 'user logged in' do
        let(:credentials) do
          {
            email: 'sophia@gmail.com',
            password: 'password123'
          }
        end
        run_test!
      end

      response '401', 'invalid credentials' do
        let(:credentials) do
          {
            email: 'wrong@gmail.com',
            password: 'wrongpassword'
          }
        end
        run_test!
      end
    end
  end


  path '/auth/logout' do
    get 'Logout the user' do
      tags 'Auth'

      response '204', 'logout successful' do
        run_test!
      end
    end
  end


  # =========================
  # TODOS
  # =========================

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

      parameter name: :todo, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          created_by: { type: :integer }
        },
        required: ['title', 'created_by'],
        example: {
          title: 'Buy groceries',
          created_by: 1
        }
      }

      response '201', 'todo created' do
        let(:todo) do
          {
            title: 'Buy groceries',
            created_by: 1
          }
        end
        run_test!
      end

      response '422', 'validation failed' do
        let(:todo) do
          {
            title: nil,
            created_by: nil
          }
        end
        run_test!
      end
    end
  end


  path '/todos/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Get a todo' do
      tags 'Todos'

      response '200', 'todo found' do
        let(:id) { Todo.create(title: 'Buy groceries', created_by: 1).id }
        run_test!
      end

      response '404', 'todo not found' do
        let(:id) { 999 }
        run_test!
      end
    end

    put 'Update a todo' do
      tags 'Todos'
      consumes 'application/json'

      parameter name: :todo, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          created_by: { type: :integer }
        },
        example: {
          title: 'Buy groceries and milk',
          created_by: 1
        }
      }

      response '200', 'todo updated' do
        let(:id) { Todo.create(title: 'Buy groceries', created_by: 1).id }
        let(:todo) do
          {
            title: 'Buy groceries and milk',
            created_by: 1
          }
        end
        run_test!
      end
    end

    delete 'Delete a todo' do
      tags 'Todos'

      response '204', 'todo deleted' do
        let(:id) { Todo.create(title: 'Buy groceries', created_by: 1).id }
        run_test!
      end
    end
  end


  # =========================
  # ITEMS
  # =========================

  path '/todos/{id}/items' do
    parameter name: :id, in: :path, type: :integer

    post 'Create a new todo item' do
      tags 'Items'
      consumes 'application/json'

      parameter name: :item, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          done: { type: :boolean }
        },
        required: ['name'],
        example: {
          name: 'Buy milk',
          done: false
        }
      }

      response '201', 'item created' do
        let(:id) { Todo.create(title: 'Shopping', created_by: 1).id }
        let(:item) do
          {
            name: 'Buy milk',
            done: false
          }
        end
        run_test!
      end
    end
  end


  path '/todos/{id}/items/{iid}' do
    parameter name: :id, in: :path, type: :integer
    parameter name: :iid, in: :path, type: :integer

    get 'Get a todo item' do
      tags 'Items'

      response '200', 'item found' do
        todo = Todo.create(title: 'Shopping', created_by: 1)
        item = todo.items.create(name: 'Buy milk', done: false)
        let(:id) { todo.id }
        let(:iid) { item.id }
        run_test!
      end
    end

    put 'Update a todo item' do
      tags 'Items'
      consumes 'application/json'

      parameter name: :item, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          done: { type: :boolean }
        },
        example: {
          name: 'Buy milk and bread',
          done: true
        }
      }

      response '200', 'item updated' do
        todo = Todo.create(title: 'Shopping', created_by: 1)
        item = todo.items.create(name: 'Buy milk', done: false)
        let(:id) { todo.id }
        let(:iid) { item.id }
        let(:item) do
          {
            name: 'Buy milk and bread',
            done: true
          }
        end
        run_test!
      end
    end

    delete 'Delete a todo item' do
      tags 'Items'

      response '204', 'item deleted' do
        todo = Todo.create(title: 'Shopping', created_by: 1)
        item = todo.items.create(name: 'Buy milk', done: false)
        let(:id) { todo.id }
        let(:iid) { item.id }
        run_test!
      end
    end
  end
end
