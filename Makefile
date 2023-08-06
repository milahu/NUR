all: public
	echo generating md files in content/
	./scripts/generate_pages.py
	find content/ -type f
	echo cleaning public/
	rm -rf public/*
	ls -A public/
	echo generating html files in public/
	hugo
	find public/ -type f
	echo committing html files in public/
	git -C public add --all
	git -C public commit -m "Publishing to gh-pages"

public:
	echo mounting gh-pages branch to public/
	git worktree prune
	git worktree add public gh-pages

publish:
	echo pushing gh-pages branch
	git -C public push origin gh-pages

clean:
	echo removing public/
	rm -rf public
