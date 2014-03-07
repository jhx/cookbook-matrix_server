# encoding: utf-8
require 'spec_helper'

describe 'matrix_server::bash' do
  cached(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['file']['header'] = 'node.file.header'
    end.converge(described_recipe)
  end # cached

  #------------------------------------------------------ directory[/etc/chef]
  describe '/etc/chef' do
    it 'creates directory with expected owner, group' do
      expect(chef_run).to create_directory(subject)
        .with(:owner => 'root', :group => 'root')
    end # it
  end # describe

  #--------------------------------- file[/etc/chef/encrypted_data_bag_secret]
  describe '/etc/chef/encrypted_data_bag_secret' do
    it 'creates file with expected owner, group, mode' do
      expect(chef_run).to create_file(subject)
        .with(:owner => 'root', :group => 'root', :mode => '0600')
    end # it
  end # describe

  #--------------------------------------------- cookbook_file[/etc/gitconfig]
  describe '/etc/gitconfig' do
    it 'creates file with expected owner, group, mode' do
      expect(chef_run).to create_cookbook_file(subject)
        .with(:owner => 'root', :group => 'root', :mode => '0644')
    end # it
  end # describe

  #----------------------------- remote_file[/etc/profile.d/git-completion.sh]
  describe '/etc/profile.d/git-completion.sh' do
    it 'creates file with expected owner, group, mode' do
      expect(chef_run).to create_remote_file(subject)
        .with(:owner => 'root', :group => 'root', :mode => '0644')
    end # it
  end # describe

  #--------------------------------- remote_file[/etc/profile.d/git-prompt.sh]
  describe '/etc/profile.d/git-prompt.sh' do
    it 'creates file with expected owner, group, mode' do
      expect(chef_run).to create_remote_file(subject)
        .with(:owner => 'root', :group => 'root', :mode => '0644')
    end # it
  end # describe

  #----------------------------------- template[/etc/profile.d/jhx_profile.sh]
  describe '/etc/profile.d/jhx_profile.sh' do
    it 'creates template with expected owner, group, mode' do
      expect(chef_run).to create_template(subject)
        .with(:owner => 'root', :group => 'root', :mode => '0644')
    end # it

    it 'renders file with expected header' do
      expect(chef_run).to render_file(subject)
        .with_content('node.file.header')
    end # it
  end # describe

  #--------------------------------------- cookbook_file[/usr/local/bin/rmate]
  describe '/usr/local/bin/rmate' do
    it 'creates file with expected owner, group, mode' do
      expect(chef_run).to create_cookbook_file(subject)
        .with(:owner => 'root', :group => 'root', :mode => '0755')
    end # it
  end # describe

  #------------------------- file[/etc/profile.d/path_opt_vagrant_ruby_bin.sh]
  describe '/etc/profile.d/path_opt_vagrant_ruby_bin.sh' do
    it 'deletes file' do
      expect(chef_run).to delete_file(subject)
    end # it
  end # describe

  #----------------------------------------- file[/etc/profile.d/path_sbin.sh]
  describe '/etc/profile.d/path_sbin.sh' do
    it 'deletes file' do
      expect(chef_run).to delete_file(subject)
    end # it
  end # describe

  #------------------------------------- file[/etc/profile.d/path_usr_sbin.sh]
  describe '/etc/profile.d/path_usr_sbin.sh' do
    it 'deletes file' do
      expect(chef_run).to delete_file(subject)
    end # it
  end # describe

end # describe
