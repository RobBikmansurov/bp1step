RSpec.shared_examples 'creates a user task' do 
  let!(:user) { FactoryBot.create(:user) }
  let!(:task) { FactoryBot.create(:task, author_id: user.id) }
  let!(:user_task) { FactoryBot.create(:user_task, task_id: task.id, user_id: user.id) }
end