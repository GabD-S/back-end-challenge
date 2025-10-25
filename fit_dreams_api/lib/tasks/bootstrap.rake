namespace :bootstrap do
  desc 'Create default users and categories (idempotent)'
  task setup: :environment do
    # Admin
    admin_email = ENV.fetch('ADMIN_EMAIL', 'admin@example.com')
    admin_password = ENV.fetch('ADMIN_PASSWORD', 'Password!23')
    admin = User.find_or_initialize_by(email: admin_email)
    if admin.new_record?
      admin.name = 'Admin'
      admin.password = admin_password
      admin.role = :admin
      admin.save!
      puts "Admin created: #{admin.email}/#{admin_password}"
    else
      puts "Admin exists: #{admin.email}"
    end

    # Professor
    prof_email = ENV.fetch('PROFESSOR_EMAIL', 'prof@example.com')
    prof_password = ENV.fetch('PROFESSOR_PASSWORD', 'Password!23')
    professor = User.find_or_initialize_by(email: prof_email)
    if professor.new_record?
      professor.name = 'Professor'
      professor.password = prof_password
      professor.role = :professor
      professor.save!
      puts "Professor created: #{professor.email}/#{prof_password}"
    else
      puts "Professor exists: #{professor.email}"
    end

    # Aluno
    aluno_email = ENV.fetch('ALUNO_EMAIL', 'aluno@example.com')
    aluno_password = ENV.fetch('ALUNO_PASSWORD', 'Password!23')
    aluno = User.find_or_initialize_by(email: aluno_email)
    if aluno.new_record?
      aluno.name = 'Aluno'
      aluno.password = aluno_password
      aluno.role = :aluno
      aluno.save!
      puts "Aluno created: #{aluno.email}/#{aluno_password}"
    else
      puts "Aluno exists: #{aluno.email}"
    end

    # Base categories
    %w[Cardio Força Yoga Dança].each do |name|
      Category.find_or_create_by!(name: name)
    end
    puts 'Categories ensured.'

    puts 'Bootstrap completed.'
  end
end
