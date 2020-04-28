require "serverspec"
require "docker"
require "spec_helper"

Docker.options[:read_timeout] = 900
CALIBRE_PORT = 8080

describe "Dockerfile" do
  before(:all) do
    @image = Docker::Image.build_from_dir('.') 

    set :os, family: :fedora
    set :backend, :docker
    set :docker_image, @image.id

  end

  it "installs the right version of fedora" do
    expect(os_version).to include("Fedora release 31")
  end

  describe 'Dockerfile#config' do
    it 'should expose the calibre port' do
      expect(@image.json['ContainerConfig']['ExposedPorts']).to include("#{CALIBRE_PORT}/tcp")
    end
  end

  describe package("calibre") do
    it { should be_installed.with_version('4.12.0') }
  end

  describe file('/data') do
    it { should be_directory }
  end

  describe file('/scripts') do
    it { should be_directory }
  end

  describe file('/scripts/startup.sh') do
    it { should be_mode 755 }
  end

  describe file('/scripts/add-books.sh') do
    it { should be_mode 755 }
  end

  describe file('/scripts/remove-books.sh') do
    it { should be_mode 755 }
  end

#  describe 'Dockerfile#running' do
#    before (:all) do
#      @container = Docker::Container.create(
#        'Image' => @image.id,
#        'HostConfig' => {
#          'Binds' => ['/tmp/data:/data'],
#          'PortBindings' => { "#{CALIBRE_PORT}/tcp" => [{ 'HostPort' => "#{CALIBRE_PORT}" }] }
#        }
#      )
#
#      @container.start('Binds' => ['/home/bradley/calibre/data:/data:Z'])
#    end

#    describe file('/data/library') do
#      it { should be_directory }
#    end

#    describe "running calibre server" do
#      describe command('/usr/bin/netstat -tunl | /usr/bin/grep 8080') do
#        its(:exit_status) { should eq 0 }
#      end
#      describe command('/usr/bin/ps -eaf | /usr/bin/grep calibre-server') do
#        its(:exit_status) { should eq 0 }
#      end 
#    end
#
#    after(:all) do
#      @container.kill
#      @container.delete(:force => true)
#    end
#  end
end
