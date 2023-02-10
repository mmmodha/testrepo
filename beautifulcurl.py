import sys
import pandas as pd

print(' Input JSON File is:', sys.argv[1])
print(' Output CSV File will be:', sys.argv[2])

output_file_name=sys.argv[2]

df = pd.read_json(sys.argv[1])
df.to_csv(output_file_name+".csv", sep='\t', encoding='utf-8')