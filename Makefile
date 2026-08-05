SKILL := ec-risk-advisor
DIST  := dist

.PHONY: package check clean

package: check
	@mkdir -p $(DIST)
	@rm -f $(DIST)/$(SKILL).skill
	@zip -r -q $(DIST)/$(SKILL).skill $(SKILL) -x '*.DS_Store'
	@echo "Paquet : $(DIST)/$(SKILL).skill"

check:
	@test -f $(SKILL)/SKILL.md || { echo "SKILL.md manquant"; exit 1; }
	@head -1 $(SKILL)/SKILL.md | grep -q '^---$$' || { echo "Frontmatter YAML absent"; exit 1; }
	@grep -q '^name: $(SKILL)$$' $(SKILL)/SKILL.md || { echo "Champ name incorrect"; exit 1; }
	@bash scripts/check_links.sh
	@echo "Contrôles OK"

clean:
	@rm -rf $(DIST)
