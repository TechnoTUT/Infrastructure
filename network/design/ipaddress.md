## WAN
IP/CIDR: 192.168.8.0/24
| # | FQDN | Description |
|---|------|-------------|
| 1 | gw.intra.technotut.net | WAN |

## Router-L3SW
IP/CIDR: 192.168.16.0/30
| # | FQDN | Description |
|---|------|-------------|
| 1 | rt.intra.technotut.net | Router |
| 2 | - | L3SW |

## VLAN10
IP/CIDR: 192.168.10.0/24
| # | FQDN | Description |
|---|------|-------------|
| 1 | - | L3SW |
| 2 | - | L2Switch #2 |

## VLAN20
IP/CIDR: 192.168.20.0/24
| # | FQDN | Description |
|---|------|-------------|
| 1 | - | L3SW |
| - | | |
| 91 | - | VM (LTSP, Diskless System) |
| 100 | - | 闇鍋PC |
| - | | |
| 201 | vj1.intra.technotut.net | NDI-Client01 |
| 202 | vj2.intra.technotut.net | NDI-Client02 |
| 203 | vj3.intra.technotut.net | NDI-Client03 |
| - | | |
| 254 | - | Wi-Fi AP #2 |

## VLAN30
IP/CIDR: 192.168.11.0/24
| # | FQDN | Description |
|---|------|-------------|
| 1 | - | L3SW |
| - | | |
| 201 | led1.intra.technotut.net | LED-System01 |
| 202 | led2.intra.technotut.net | LED-System02 |
| 203 | led3.intra.technotut.net | LED-System03 |
| 204 | led4.intra.technotut.net | LED-System04 |
| 205 | led5.intra.technotut.net | LED-System05 |
| 206 | led6.intra.technotut.net | LED-System06 |

## VLAN99
IP/CIDR: 192.168.99.0/24
| # | FQDN | Description |
|---|------|-------------|
| 1 | sw3.intra.technotut.net | L3SW |
| 2 | sw2.intra.technotut.net | L2Switch #2 |
| - | | |
| 4 | sw4.intra.technotut.net | L2Switch #4 |
| 5 | sw5.intra.technotut.net | L2Switch #5 |
| 6 | sw6.intra.technotut.net | L2Switch #6 |
| - | | |
| 11 | blt.intra.technotut.net | LXC (Beat-Link-Trigger) |
| - | | |
| 21 | pj1.intra.technotut.net | Projector01 |
| 22 | pj2.intra.technotut.net | Projector02 |
| - | | |
| 33 | kube.intra.technotut.net | VM (Kubernetes) |
| - | | |
| 51 | dns.intra.technotut.net | LXC (BIND) |
| 52 | np.intra.technotut.net | LXC (nginx) |
| - | | |
| 91 | netboot.intra.technotut.net | VM (LTSP, Diskless System) |
| - | | |
| 254 | ap.intra.technotut.net | Wi-Fi AP #1 |
