# Rake tasks for BadgeApp

# Run tests last. That way, runtime problems (e.g., undone migrations)
# do not interfere with the other checks.


desc 'Stub do-nothing jobs:work task to eliminate Heroku log complaints'
task 'jobs:work' do
end
