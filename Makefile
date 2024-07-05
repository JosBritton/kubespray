.SILENT:
.DEFAULT_GOAL := all

export ANSIBLE_HOST_KEY_CHECKING := "False"

.PHONY: all
all: .venv/lock
	. .venv/bin/activate && \
	ansible-playbook -i inventory/cluster/hosts.yml --become --become-user=root site.yml
	ln -sfT "$$(realpath inventory/cluster/artifacts/admin.conf)" "$(HOME)/.config/kube"

.PHONY: install
install: .venv/lock
	ln -sfT "$$(realpath inventory/cluster/artifacts/admin.conf)" "$(HOME)/.config/kube"

.venv/lock: requirements.txt
	python3 -m venv .venv/

	. .venv/bin/activate && \
	python3 -m pip install -U -r requirements.txt

	touch .venv/lock

.PHONY: mitogen
mitogen:
	@echo Mitogen support is deprecated.
	@echo Please run the following command manually:
	@echo   ansible-playbook -c local mitogen.yml -vv

.PHONY: clean
clean:
	rm -f "$(HOME)/.config/kube"
	rm -rf .venv/
	rm -rf dist/
	rm -f *.retry
