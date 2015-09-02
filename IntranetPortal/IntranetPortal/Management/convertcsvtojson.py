import sys
import json

def convert(fileName):
	obj = {'items': []}
	file = open(fileName)
	for line in file:
		parts = line.split(',')
		if parts[1] == '#':
			if not 'head' in obj:
				obj['head'] = parts[0]
			else:
				print json.JSONEncoder().encode(obj)
				print ','
				obj = {'items': []}
				obj['head'] = parts[0]		

		else:
			if parts[0]:
				item = {}
				item['label'] = parts[0]
				if parts[1] != '*':
					item['type'] = parts[1]
				obj['items'].append(item)

	print json.JSONEncoder().encode(obj)

if __name__=='__main__':
	convert(sys.argv[1])