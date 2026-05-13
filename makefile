PP_DIR = pp
HITLS_DIR = hitls
MASTIK_DIR = Mastik

CCFLAGS = -O2 -Wall -Wextra

.PHONY: all
all: alice app bob mallory eve

alice: alice.c
	$(CC) $(CCFLAGS) -o $@ $^

app: app.c $(HITLS_DIR)/*.c
	$(CC) $(CCFLAGS) -o $@ $^ -I$(HITLS_DIR) -L$(HITLS_DIR) -lhitls_crypto -Wl,-rpath=$(HITLS_DIR)

bob: bob.c $(HITLS_DIR)/*.c
	$(CC) $(CCFLAGS) -o $@ $^ -I$(HITLS_DIR) -L$(HITLS_DIR) -lhitls_crypto -Wl,-rpath=$(HITLS_DIR)

mallory: mallory.c $(HITLS_DIR)/*.c $(PP_DIR)/*.c $(MASTIK_DIR)/libmastik.a
	$(CC) $(CCFLAGS) -o $@ $^ -I$(HITLS_DIR) -I$(PP_DIR) -I$(MASTIK_DIR) -L$(HITLS_DIR) -lhitls_crypto -L$(MASTIK_DIR) -lmastik -Wl,-rpath=$(HITLS_DIR):$(MASTIK_DIR)

eve: eve.c $(HITLS_DIR)/*.c
	$(CC) $(CCFLAGS) -o $@ $^ -I$(HITLS_DIR) -L$(HITLS_DIR) -lhitls_crypto -Wl,-rpath=$(HITLS_DIR)

$(MASTIK_DIR)/libmastik.a: $(MASTIK_DIR)/Makefile
	$(MAKE) -C $(MASTIK_DIR) && cp $(MASTIK_DIR)/src/libmastik.a $(MASTIK_DIR)

$(MASTIK_DIR)/Makefile:
	cd $(MASTIK_DIR) && ./configure

.PHONY: clean
clean:
	rm -f alice app bob mallory eve
	rm -f $(MASTIK_DIR)/libmastik.a

.PHONY: cleanup
cleanup: clean
	$(MAKE) -C $(MASTIK_DIR) clean
