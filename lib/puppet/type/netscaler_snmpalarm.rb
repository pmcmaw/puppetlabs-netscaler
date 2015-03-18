require 'puppet/parameter/netscaler_name'
require 'puppet/property/netscaler_truthy'

Puppet::Type.newtype(:netscaler_snmpalarm) do
  @doc = 'Manage basic netscaler network IP objects.'

  apply_to_device
  ensurable do
    defaultto :present
    newvalue(:present) do
      provider.set_state(resource[:state])
    end
    newvalue(:absent) do
      provider.set_state('DISABLED')
    end
  end

  newparam(:name, :namevar => true) do #<String>
    desc "Name of the SNMP alarm."
    munge do |value|
      value.upcase
    end
  end

  newproperty(:alarm_threshold) do #<Double>
    desc "Value for the high threshold. The NetScaler appliance generates an SNMP trap message when the value of the attribute associated with the alarm is greater than or equal to the specified high threshold value."
  end

  newproperty(:normal_threshold) do #<Double>
    desc "Value for the normal threshold. A trap message is generated if the value of the respective attribute falls to or below this value after exceeding the high threshold."
  end

  newproperty(:severity) do #<String>
    desc "Severity level assigned to trap messages generated by this alarm. The severity levels are, in increasing order of severity, Informational, Warning, Minor, Major, and Critical.
    Possible values = Critical, Major, Minor, Warning, Informational"
    munge do |value|
      value.capitalize
    end
  end

  newproperty(:time_interval) do #<Double>
    desc "Interval, in seconds, at which the NetScaler appliance generates SNMP trap messages when the conditions specified in the SNMP alarm are met. Can be specified for the following alarms: SYNFLOOD, HA-VERSION-MISMATCH, HA-SYNC-FAILURE, HA-NO-HEARTBEATS, HA-BAD-SECONDARY-STATE, CLUSTER-NODE-HEALTH, CLUSTER-NODE-QUORUM, CLUSTER-VERSION-MISMATCH, PORT-ALLOC-FAILED and APPFW traps. Default trap time intervals: SYNFLOOD and APPFW traps = 1sec, PORT-ALLOC-FAILED = 3600sec(1 hour), Other Traps = 86400sec(1 day).
Default value: 1"
  end

  newproperty(:state, :parent => Puppet::Property::NetscalerTruthy) do #<String>
    truthy_property("Current state of the SNMP alarm. The NetScaler appliance generates trap messages only for SNMP alarms that are enabled.
Possible values = ENABLED, DISABLED","ENABLED","DISABLED")
  end

  newproperty(:logging, :parent => Puppet::Property::NetscalerTruthy) do #<String>
    truthy_property("Logging status of the alarm. When logging is enabled, the NetScaler appliance logs every trap message that is generated for this alarm.
Default value: ENABLED
Possible values = ENABLED, DISABLED","ENABLED","DISABLED")
  end
end
