# Foreman Template for Zabbix

## Idea

Using Zabbix's trapper+Foreman API (shell+jq) we're able to report interesting values and present it in Zabbix and Grafana.

## Script

* `report_foreman`
* usage: `./report_foreman.sh [-s servername] [-u api_user] [-p api_password] [-z zabbix_server]`

## Zabbix Template

* `zbx_foreman_template.xml`

## Grafana dashboard

### Main panel

![dashboard](https://www.dropbox.com/s/ygxol97j7ak7z4x/dashboard.png?raw=1)

### Stats

![stats](https://www.dropbox.com/s/fqqzgddqjqp6y55/stats.png?raw=1)

### Pie

![pie](https://www.dropbox.com/s/ypbb4isqep6g140/pie.png?raw=1)

## Usage

1. Create user in Foreman (Internal, with role: Viewer)

1. Put script `report_foreman.sh` in proper place (for example `/usr/local/bin`)

* make sure you have `zabbix_sender` installed
* fill all details in variables or run script passing parameters

```bash
./report_foreman.sh -s foremanserver.domain.com -u api -p password -z zabbix.domain.com
```

1. Create cron job on server you're running script

```conf
*/1 * * * * /usr/local/bin/report_foreman.sh
```

1. Import `Template Foreman` (zbx_foreman.template.xml) to your Zabbix server and apply it to the proper host
1. Import dashboard to Grafana and change source

## Contact

[marcin(at)bojko.com.pl](mailto:marcin@bojko.com.pl)

[website])marcinbojko.wordpress.com)