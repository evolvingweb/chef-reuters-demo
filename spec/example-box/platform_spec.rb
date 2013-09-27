require 'spec_helper'

describe 'platform' do
  describe 'build-essential' do
    describe package('build-essential') do
      it { should be_installed }
    end

    describe command('gcc -v') do
      it { should return_exit_status 0 }
    end

    describe command('make -v') do
      it { should return_exit_status 0 }
    end
  end

  describe user("amir") do
    it { should exist }
    it { should belong_to_group "amir" }
    it { should have_login_shell '/bin/bash' }
    it { should have_authorized_key "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFPHojxf7pNIZAEY+R0n40mivBxI+tu2B2+8iqBvE2XLjQmf6tzY27tgV+abVjGD2OBiVjJCLh8jFAsXhyHWxFkIPjwcnKbT++qnlnoa2oR0u2/Cs9HE4hQZ6R7JZoXrnx44i8loruFxPv4i/LW6wV88fQqap6du2tdrZGgJESlAftQeRSLRvYnuMx1b8RpGK1p1hseU+RnoQhB9iocLkm1I/nt8acfeschWWpz6yg0E57+5xyMh0tkCnfyQmD7Aiis5NUHiix4koHslTXcqGTk6CizMEAp7e7yc5GSBlRe+GKEm8AiG/YDz0xEnhFl9siObTwcqXNRDJhxBmeZZ1P amir@amir-tp" }
  end
end
