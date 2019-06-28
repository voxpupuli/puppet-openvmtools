# == Class: openvmtools
#
# This class handles installing the Open Virtual Machine Tools.
#
# === Parameters:
#
# [*ensure*]
#   Ensure if present or absent.
#   Default: present
#
# [*autoupgrade*]
#   Upgrade package automatically, if there is a newer version.
#   Default: false
#
# [*desktop_package_name*]
#   Name of the desktop package.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*package_name*]
#   Name of the package.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*service_enable*]
#   Start service at boot.
#   Default: true
#
# [*service_ensure*]
#   Ensure if service is running or stopped.
#   Default: running
#
# [*service_hasstatus*]
#   Service has status command.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*service_name*]
#   Name of openvmtools service.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*service_pattern*]
#   Pattern to look for in the process table to determine if the daemon is
#   running.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: vmtoolsd
#
# [*with_desktop*]
#   Whether or not to install the desktop/GUI support.
#   Default: false
#
# === Sample Usage:
#
#   include openvmtools
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
# Vox Pupuli <voxpupuli@groups.io>
#
# === Copyright:
#
# Copyright (C) 2017 Vox Pupuli
#
class openvmtools (
  Enum['absent','present'] $ensure               = 'present',
  Boolean                  $autoupgrade          = false,
  String[1]                $desktop_package_name = 'open-vm-tools-desktop',
  String[1]                $package_name         = 'open-vm-tools',
  Boolean                  $service_enable       = true,
  Stdlib::Ensure::Service  $service_ensure       = 'running',
  Boolean                  $service_hasstatus    = true,
  String[1]                $service_name         = 'vmtoolsd',
  Optional[String[1]]      $service_pattern      = undef,
  Boolean                  $supported            = false,
  Boolean                  $with_desktop         = false,
) {

  if $facts['virtual'] == 'vmware' {
    if $supported {
      if $ensure == 'present' {
        $package_ensure = $autoupgrade ? {
          true    => 'latest',
          default => 'present',
        }
        $service_ensure_real = $service_ensure
      } else {  # ensure == 'absent'
        $package_ensure = 'absent'
        $service_ensure_real = 'stopped'
      }

      $packages = $with_desktop ? {
        true    => [ $package_name, $desktop_package_name ],
        default => [ $package_name ],
      }

      package { $packages:
        ensure => $package_ensure,
      }

      service { $service_name:
        ensure    => $service_ensure_real,
        enable    => $service_enable,
        hasstatus => $service_hasstatus,
        pattern   => $service_pattern,
        require   => Package[$packages],
      }
    } else { # ! $supported
      notice(sprintf("Your operating system %s is unsupported and will not have \
the Open Virtual Machine Tools installed.", $::operatingsystem))
    }
  } else {
    # If we are not on VMware, do not do anything.
  }
}
