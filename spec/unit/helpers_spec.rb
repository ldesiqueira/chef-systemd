require 'spec_helper'

describe Systemd::Helpers do
  let(:unit) do
    ChefSystemdCookbook::ServiceResource.new('unit')
  end

  let(:drop_in_unit) do
    d = ChefSystemdCookbook::ServiceResource.new('drop_in')
    d.drop_in(true)
    d.override 'httpd'
    d
  end

  let(:user_unit) do
    d = ChefSystemdCookbook::ServiceResource.new('user')
    d.mode :user
    d
  end

  let(:daemon) do
    ChefSystemdCookbook::TimesyncdResource.new('daemon')
  end

  let(:drop_in_daemon) do
    d = ChefSystemdCookbook::TimesyncdResource.new('drop_in')
    d.drop_in(true)
    d
  end

  it 'lists the correct stub units' do
    expect(Systemd::Helpers::STUB_UNITS).to match_array [:target]
  end

  it 'lists the correct daemons' do
    expect(Systemd::Helpers::DAEMONS).to match_array [
      :journald, :logind, :resolved, :timesyncd
    ]
  end

  it 'lists the correct unit types' do
    expect(Systemd::Helpers::UNITS).to match_array [
      :service, :socket, :mount, :automount,
      :swap, :target, :path, :timer, :slice
    ]
  end

  it 'sets the appropriate local configuration root' do
    expect(Systemd::Helpers.local_conf_root).to eq '/etc/systemd'
  end

  it 'sets the appropriate system unit configuration root' do
    expect(Systemd::Helpers.unit_conf_root(unit)).to eq '/etc/systemd/system'
  end

  it 'sets the appropriate user unit configuration root' do
    expect(Systemd::Helpers.unit_conf_root(user_unit)).to eq '/etc/systemd/user'
  end

  it 'sets the appropriate daemon conf path' do
    expect(Systemd::Helpers.conf_path(daemon)).to eq '/etc/systemd/timesyncd.conf.d/daemon.conf'
  end

  it 'sets the appropriate conf drop_in path' do
    expect(Systemd::Helpers.conf_path(drop_in_daemon)).to eq '/etc/systemd/timesyncd.conf.d/drop_in.conf'
  end

  it 'sets the appropriate unit drop_in root' do
    expect(Systemd::Helpers.conf_drop_in_root(drop_in_unit)).to eq '/etc/systemd/system/httpd.service.d'
  end

  it 'sets the appropriate unit drop_in path' do
    expect(Systemd::Helpers.conf_path(drop_in_unit)).to eq '/etc/systemd/system/httpd.service.d/drop_in.conf'
  end

  it 'sets the appropriate unit path' do
    expect(Systemd::Helpers.conf_path(unit)).to eq '/etc/systemd/system/unit.service'
  end

  it 'performs a correct unit hash->ini conversion' do
    expect(
      Systemd::Helpers.ini_config({
        :unit=>["Description=test unit"],
        :install=>[],
        :service=>["MemoryLimit=5M", "User=nobody", "Type=oneshot"]
      })
    ).to eq "[Unit]\nDescription=test unit\n\n[Service]\nMemoryLimit=5M\nUser=nobody\nType=oneshot\n"
  end
end
