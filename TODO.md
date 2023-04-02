# TODO

- Run scripts in parallel
- Sanitize input: Ensure that any user-provided input is sanitized and validated before executing it. This helps prevent attacks like Cross-Site Scripting (XSS) and SQL injection.
- Isolate user code: Run user-uploaded code in an isolated environment (e.g., using containers or sandboxing) to minimize the potential impact of malicious code on your system. For example, you can use technologies like Docker or solutions like Google Cloud Functions.
- Use https://www.npmjs.com/package/vm2
- Limit resource usage: Impose limits on CPU, memory, and other system resources that the user code can consume to prevent Denial of Service (DoS) attacks. This can be done through containerization technologies, such as Docker or Kubernetes, that allow you to set resource limits on containers.
- Rate limiting: Implement rate limiting to prevent users from overloading your system with requests or uploads.
