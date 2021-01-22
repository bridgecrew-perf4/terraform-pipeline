terraform {
	required_providers {
		ontap = {
			version = "0.1"
			source = "netapp.com/warrenb/ontap"
		}
	}
}

provider "ontap" {
	username = "admin"
	password = "Netapp1!"
	cluster = "10.216.2.130"
}

/*
data "ontap_aggregate" "aggr0" {}
*/

data "ontap_cluster" "cluster" {}

resource "ontap_svm" "svm" {
	name = "svm2"
	dns_domains = [ "csopslabs.netapp.com" ]
	dns_servers = [ "10.61.80.122" ]

	ip_interface {
		name = "iscsi_a"
		broadcast_domain = "Default"
		ip_address = "10.216.2.132"
		ip_netmask = 24
		home_node = data.ontap_cluster.cluster.nodes[0].name		
		service_policy = "default-data-blocks"
	}

	ip_interface {
		name = "iscsi_b"
		broadcast_domain = "Default"		
		ip_address = "10.216.2.133"
		ip_netmask = 24
		home_node = data.ontap_cluster.cluster.nodes[0].name
		service_policy = "default-data-blocks"
	}	

	route {
		destination_address = "0.0.0.0"
		destination_netmask = 0
		gateway = "10.216.2.1"
	}	
}
/*
resource "ontap_iscsi_service" "iscsi0" {
	svm_name = "svm1"
}


resource "ontap_export_policy" "ep1" {
	name = "terraform"
	svm_name = "svm1"
	
	rule {
		superuser = [ "sys" ]
		rw_rule = [ "sys" ]
		ro_rule = [ "sys" ]
		protocols = [ "nfs" ]
		clients = [ "10.249.13.0/24" ]
	}

	rule {
		protocols = [ "cifs" ]
		clients = [ "10.0.0.0/8" ]		
	}

	rule {
		protocols = [ "nfs4", "cifs" ]
		anonymous_user = 0
		clients = [ "172.16.0.0/16" ]
	}
}

resource "ontap_volume" "vol2" {
	name 			= "terraform3"
	svm_name 		= ontap_svm.svm.name
	language		= "ar"
	size 			= 20971520
	export_policy	= "default" // ontap_export_policy.ep1.name
	aggregate {
		name = data.ontap_aggregate.aggr0.name
	}
}

resource "ontap_nfs_service" "nfs" {
	svm_name = "svm1" // ontap_svm.svm.name
	vstorage_enabled = true
}*/
/*
resource "ontap_lun" "lun0" {
	svm_name = "svm1" // ontap_svm.svm.name
	enabled = true
	volume_name = ontap_volume.vol2.name
	logical_unit = "lun0"
	size = 20971520 * 2
	os_type = "windows"
}

resource "ontap_volume" "clone" {
	name 			= "terraform4"
	svm_name 		= "svm1"
	language		= "en.utf-8"
	size 			= 20971520
	export_policy	= "default" // ontap_export_policy.ep1.name
	aggregate {
		name = data.ontap_aggregate.aggr0.name
	}
}

resource "ontap_volume" "vol2" {
	name 			= "terraform"
	svm_name 		= ontap_svm.svm.name
	size 			= 20971520 * 3
	export_policy	= "default" // ontap_export_policy.ep1.name
	aggregate {
		name = data.ontap_aggregate.aggr0.name
	}
} 

resource "ontap_igroup" "ig0" {
	name 		= "terraform"
	svm_name 	= ontap_svm.svm.name
	os_type 	= "windows"
	protocol 	= "iscsi"

	initiators 	= [ "iqn.1991-05.com.microsoft:warrenb-pc.hq.netapp.com" ]
}

resource "ontap_lun" "lun" {
	svm_name = ontap_svm.svm.name 
	volume_name = ontap_volume.vol2.name
	logical_unit = "lun0"
	size = 20971520 
	os_type = "windows"
}

resource "ontap_lun_map" "lm0" {
	svm_name = ontap_svm.svm.name
	lun_name = ontap_lun.lun.name
	igroup_name = ontap_igroup.ig0.name
}

resource "ontap_svm_peer" "p0" {
	svm_name = ontap_svm.svm.name
	peer_svm_name = "svm1"
	peer_cluster_name = data.ontap_cluster.cluster.name
	applications = [ "snapmirror" ]
}*/