# Pulp Master Service
class pulp::service {
  if $::operatingsystemmajrelease == 7 {
    exec { 'pulp refresh system service':
      command     => '/bin/systemctl daemon-reload',
      before      => Service['pulp_celerybeat', 'pulp_workers', 'pulp_resource_manager'],
      refreshonly => true,
    }
  }

  $messaging_service = $broker::broker_service 

  service { 'pulp_celerybeat':
    ensure     => running,
    require    => [Service[mongodb], Service[$messaging_service]],
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  service { 'pulp_workers':
    ensure     => running,
    require    => [Service[mongodb], Service[$messaging_service]],
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    status     => 'service pulp_workers status | grep "node reserved_resource_worker"',
  }

  service { 'pulp_resource_manager':
    ensure     => running,
    require    => [Service[mongodb], Service[$messaging_service]],
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    status     => 'service pulp_resource_manager status | grep "node resource_manager"',
  }

}
