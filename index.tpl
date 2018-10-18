<head>
    <title>Keyword search enginee</title>
</head>
<style>
	th {
	    text-align: left;
	    padding: 8px;
	}
</style>
<body>
% if user_email:
	<form action="/logout" method="post">
        <input value="Sign out" type="submit" style="float:right;margin-left:0.5em"/>
    </form>
	<span style="float:right;">Welcome, {{user_email}}</span>
	<br>

% else:
	<form action="/login_step1" method="post">
        <input value="Sign in" type="submit" style="float:right;margin-left:0.5em"/>
    </form>
	<span style="float:right;">Welcome, anonymous</span>
	<br>
	
% end
    <div><h1 style="text-align:center;">NEET SEARCH ENGINEE</h1> 
	<div><image src="/static/xiaomai.jpeg" style="width:10%;margin:auto;display:block"/></div>
	<form action="/" method="post">
    	<div style="text-align:center">Please enter the keywords: <input name="keywords" type="text" />
        <input value="search" type="submit" />
		</div>
    </form>
	
<!--show the results if keywords entered -->
% if keywords: 
	<h1 align="center">Search for "{{keywords}}"</h1>

<!--count is a dict storing each keyword and its number of occurence, it is used in result table-->
<!--temp dict is used in the case where there are already 20 keywords stored in the record dict, those new keywords are temporarily stored in temp and will be used to compare with the current top 20 popular keywords. Keywords having larger number of occurence will be put or remained in record dict-->
<%
	count = {}  
	
	for word in keywords.lower().split():
		if word not in count:
			count[word]=1
		else:
			count[word]+=1
		end
		
		if user_email:
			if word not in record:
				if len(record) < 10:
					record[word]=1
				else: 
					record.popitem(last=False)	
					record[word]=1			
				end
			else:
				temp = record[word]
				del record[word]
				record[word]= temp+1
			end
		end
	end
	
	
	
	
	
%>
	<table id=”results” style="margin:auto">
		<tr style="font-size:1.5em">
			<th>Word</th>
			<th>Count</th>
		</tr>
% for key in keywords.lower().split():
	% if key in count:
		<tr style="font-size:1.5em">
			<td style="padding-left:1.5em">{{key}}</td>
			<td align="center">{{count[key]}}</td>
		</tr>
	% del count[key]
	% end
% end
	</table>
% end

<!--show top 20 most popular keywords if any record exists -->
% if len(record)>0 and user_email:
	<h1 align="center">10 Most recently search words:</h1>
	<table id=”history” style="margin:auto">
		<tr style="font-size:1.5em">
			<th>No.</th>
			<th>Word</th>
			<th>Count</th>
		</tr>
% counter=0
% for key,value in reversed(record.items()):
% counter+=1	
		<tr style="font-size:1em">
			<td align="center">{{counter}}</td>
			<td style="padding-left:1.5em">{{key}}</td>
			<td align="center">{{value}}</td>
		</tr>
% end
	</table>
% end
</body>