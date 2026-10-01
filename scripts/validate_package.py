"""Offline checks for public exports, connections, metadata and demo arithmetic."""
import json, pathlib, re, xml.etree.ElementTree as ET
from decimal import Decimal

ROOT = pathlib.Path(__file__).resolve().parents[1]
files = list((ROOT/'workflows').glob('*.json')) + list((ROOT/'supporting-workflows').glob('*.json'))
assert len(files)==5
for file in files:
    data=json.loads(file.read_text())
    assert data['active'] is False and data['pinData']=={}
    names=[n['name'] for n in data['nodes']]
    assert len(names)==len(set(names))
    for n in data['nodes']:
        assert 'credentials' not in n and 'webhookId' not in n
    for source, kinds in data['connections'].items():
        assert source in names, (file,source)
        for outputs in kinds.values():
            for output in outputs:
                for edge in output: assert edge['node'] in names, (file,edge)
    serialized=file.read_text()
    assert 'hrnaresh39.app.n8n.cloud' not in serialized
    assert 'hrnareshabd@gmail.com' not in serialized
    assert 'instanceId' not in serialized
    assert not re.search(r'AIza[0-9A-Za-z_-]{20,}|sk-[A-Za-z0-9]{20,}|gh[pousr]_[A-Za-z0-9]{20,}',serialized)
    print(f'{file.name}: {len(names)} nodes, inactive, connected, credential-free')

metadata=json.loads((ROOT/'database/schema-metadata.json').read_text())
tables={t['name'] for t in metadata['tables']}
assert len(tables)==9
schema=(ROOT/'database/schema.sql').read_text()
for table in tables: assert f'CREATE TABLE public.{table} ' in schema
assert 'UNIQUE (namespace, incident_date)' in schema
assert 'PRIMARY KEY (namespace, run_id)' in schema
ET.parse(ROOT/'assets/architecture.svg')
baseline=Decimal('950.15')*30
target=Decimal('149')*4+Decimal('9999')
change=((target-baseline)/baseline*100).quantize(Decimal('.01'))
assert (baseline,target,change)==(Decimal('28504.50'),Decimal('10595'),Decimal('-62.83'))
assert json.loads((ROOT/'samples/grounded-rca.json').read_text())['critic']['pass'] is True
assert json.loads((ROOT/'samples/dry-run-output.json').read_text())['status']=='DRY_RUN_COMPLETED'
for md in ROOT.rglob('*.md'):
    for target in re.findall(r'\]\(([^)]+)\)',md.read_text()):
        if not target.startswith(('https:','http:','#')):
            assert (md.parent/target.split('#')[0]).exists(), (md,target)
print('Schema, SVG, relative document links and synthetic demo arithmetic verified.')
