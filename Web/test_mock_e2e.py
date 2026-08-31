"""
End-to-end HTTP test for the mock test submit flow.
Run: python test_mock_e2e.py
"""
import requests
import re
import sys

s = requests.Session()
base = "http://127.0.0.1:8000"

# ── 1. Get login page ─────────────────────────────────────────────────────────
r = s.get(f"{base}/users/login/")
print(f"[1] Login page: {r.status_code}")

csrf = re.search(r'csrfmiddlewaretoken.*?value="([^"]+)"', r.text)
csrf = csrf.group(1) if csrf else ""
print(f"    CSRF token found: {bool(csrf)}")

# ── 2. Login ──────────────────────────────────────────────────────────────────
# Try a few common credentials
credentials = [
    ("admin", "admin"),
    ("admin", "admin123"),
    ("admin", "pass1234!"),
]
logged_in = False
for user, pwd in credentials:
    r = s.post(
        f"{base}/users/login/",
        data={"csrfmiddlewaretoken": csrf, "username": user, "password": pwd},
        allow_redirects=True,
    )
    if "login" not in r.url:
        print(f"[2] Logged in as '{user}' — redirected to: {r.url}")
        logged_in = True
        break
    print(f"[2] Login failed for '{user}' — still at: {r.url}")

if not logged_in:
    print("    Could not log in. Trying to access mock tests unauthenticated...")

# ── 3. Mock tests list page ───────────────────────────────────────────────────
r = s.get(f"{base}/courses/mock-tests/")
print(f"[3] Mock tests page: {r.status_code} — url: {r.url}")

# ── 4. Select course 1 ────────────────────────────────────────────────────────
r = s.get(f"{base}/courses/mock-tests/?course=1")
print(f"[4] Course 1 questions: {r.status_code}")

q_ids = re.findall(r'name="q_(\d+)"', r.text)
print(f"    Question IDs: {q_ids}")
if not q_ids:
    print("    ERROR: No questions found on page! Snippet:")
    print(r.text[:1000])
    sys.exit(1)

csrf2_match = re.search(r'csrfmiddlewaretoken.*?value="([^"]+)"', r.text)
csrf2 = csrf2_match.group(1) if csrf2_match else csrf

# ── 5. Submit mock test ───────────────────────────────────────────────────────
post_data = {"csrfmiddlewaretoken": csrf2, "course_id": "1"}
for qid in q_ids:
    post_data[f"q_{qid}"] = "A"  # answer every question with A

print(f"[5] Submitting {len(q_ids)} answers to /courses/mock-tests/submit/...")
r = s.post(
    f"{base}/courses/mock-tests/submit/",
    data=post_data,
    allow_redirects=True,
)
print(f"[6] Submit response: status={r.status_code}, url={r.url}")

if r.status_code == 200:
    # Check for template crash
    if "TemplateSyntaxError" in r.text or "Server Error" in r.text[:400]:
        print("    FAIL — template/server error detected:")
        print(r.text[:800])
        sys.exit(1)

    # Look for key result page content
    score_m = re.search(r"(\d+)\s*/\s*(\d+)", r.text)
    pct_m   = re.search(r"(\d+)%", r.text)
    has_correct = "Correct" in r.text
    has_wrong   = "Wrong"   in r.text
    has_total   = "Total"   in r.text
    has_grade   = any(g in r.text for g in ["Excellent!", "Good effort!", "Keep practising!"])

    print(f"    Score pattern : {score_m.group(0) if score_m else 'NOT FOUND'}")
    print(f"    Percentage    : {pct_m.group(0) if pct_m else 'NOT FOUND'}")
    print(f"    Correct/Wrong/Total chips: {has_correct} / {has_wrong} / {has_total}")
    print(f"    Grade message : {has_grade}")

    if has_correct and has_wrong and has_total and has_grade:
        print("\n✅  PASS — mock test submission works end-to-end!")
    else:
        print("\n⚠️  Partial — some elements missing, check the page source below:")
        # Print a small snippet of the result page body
        body_start = r.text.find("Score Card")
        if body_start == -1:
            body_start = r.text.find("score")
        print(r.text[max(0, body_start):body_start + 800])
else:
    print(f"    FAIL — unexpected status {r.status_code}")
    print(r.text[:600])
    sys.exit(1)
