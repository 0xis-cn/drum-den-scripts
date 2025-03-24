function update-lexicon
	set filepath $argv[1]
	echo Aloha! Mat-ling is to convert your notes.
	echo -e Creating webpages for: \e\[96m$filepath\e\[0m 
	for i in (ls $filepath/*.md)
		set html (string replace \.md \.html $i)[1]
		set brief (string split -r -m1 / $i)[2]
		awk '{
			sub(/\.md)/, ".html)");
			sub(/files\\\\/, "files/");
			if (match($0, "   $"))
				sub(/   *$/, "\\n");
			else
				$0 = $0 "  "; print;
		}' $i | pandoc -o $html
		echo '<aside>' >> $html
		echo Generated html for \e\[96m$brief\e\[0m
	end
	for i in (ls $filepath/*.md)
		set item (string replace \.md \.html (string split -r -m1 / $i)[2])
		set title (string sub -s 3 (head -n 1 $i))
		for j in (awk '{
			while (match($0, /\\((\\w+)\\.md\\)/, out)) {
				print out[1];
				$0 = substr($0, RSTART + RLENGTH);
			}
		}' $i)
			set excerpt (grep -m 1 $j.md $i | awk '{
				gsub(/(\\*|\\[|\\]|\\(\w+\\.md\\))/, "");
				print;
			}')
			printf '<a href="%s"><p>%s</p><p>%s</p></a>' $item $title $excerpt >> $filepath/$j.html
		end
	end
end
