patch-p: patch install publish push
minor-p: minor install publish push
major-p: major install publish push

install:
	poetry install

publish:
	poetry publish --build

patch:
	bump2version patch

minor:
	bump2version minor

major:
	bump2version major

push:
	git push origin master

lint:
	ruff check ./workflow --fix

.PHONE: *
