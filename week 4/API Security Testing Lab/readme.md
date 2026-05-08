# Lab 1 — IDOR / RoleID Manipulation

## Description

The first lab focused on Broken Object Level Authorization (BOLA) through manipulation of the `roleid` parameter within the user profile update functionality. The application failed to validate authorization checks properly, allowing privilege escalation by modifying the role identifier value in the intercepted request.

---

## Testing Methodology

### Intercept Request

Requests were intercepted using Burp Suite during profile update operations.

Example intercepted request:

```http id="z7m2k4"
POST /api/profile/update HTTP/1.1
```

### Parameter Manipulation

The request body originally contained:

```json id="w5p8n1"
{
  "username":"wiener",
  "roleid":1
}
```

The `roleid` value was modified manually:

```json id="x3q6v9"
{
  "username":"wiener",
  "roleid":2
}
```
<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/a32cdf4e-a728-498b-8864-5aed54f0ee58" />

### Result

The server accepted the modified request and granted administrative privileges to the user account without proper authorization validation, confirming the presence of a privilege escalation and BOLA vulnerability.
<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/d5ed97ed-d6bd-4baf-bf47-6fee30800404" />

---

# Findings

| Test ID | Vulnerability                            | Severity | Endpoint            |
| ------- | ---------------------------------------- | -------- | ------------------- |
| 008     | Broken Object Level Authorization (BOLA) | Critical | /api/profile/update |

---

# Impact

An attacker could manipulate the `roleid` parameter to escalate privileges and gain unauthorized administrative access. This could lead to unauthorized access to restricted functionality, sensitive information exposure, and complete compromise of application integrity.

---

# Remediation

* Enforce server-side authorization validation
* Prevent modification of sensitive role parameters from client requests
* Implement strict role-based access control (RBAC)
* Validate privilege changes through backend authorization logic
* Log and monitor suspicious privilege escalation attempts


# Lab 2 — GraphQL Information Disclosure Testing

## Description

The second lab focused on testing GraphQL API security through schema enumeration and information disclosure analysis. The assessment evaluated whether hidden or sensitive data could be accessed by abusing GraphQL queries and introspection functionality.

---

# Testing Methodology

### GraphQL Endpoint

```text id="u8k3x1"
/graphql/v1
```

---

# Initial Analysis

The blog application retrieved posts through GraphQL queries. During traffic analysis in Burp Suite HTTP History, sequential blog post identifiers were observed within GraphQL responses.

Example:

```text id="v6m2p9"
Post IDs: 1, 2, 4
```

The absence of post ID `3` indicated the presence of a hidden or restricted blog post.

---

# Introspection Query Testing

The GraphQL request was sent to Burp Suite Repeater and an introspection query was inserted using:

```text id="r5t1y8"
GraphQL → Set introspection query
```
<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/994eed67-5ad0-485d-b9ce-e4555290a7dc" />

The server response exposed internal schema details and revealed the presence of a sensitive field:

```text id="f4n7w3"
postPassword
```

This confirmed that introspection was enabled and sensitive backend fields were accessible.

---

# Query Manipulation

The original GraphQL query variables were modified manually by changing the hidden post identifier:

```json id="m9x2c6"
"id": 3
```

The following field was added to the GraphQL query:

```graphql id="q7k4v1"
postPassword
```

Example modified query:

```graphql id="p2j8n5"
{
  getBlogPost(id: 3) {
    title
    postPassword
  }
}
```
<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/a2e537d3-0e37-4b0f-bc1b-2d629a169ad1" />

---

# Result

The server returned the hidden blog post password and exposed sensitive data that should not have been accessible to standard users. The vulnerability demonstrated improper access control and excessive information disclosure through GraphQL queries and introspection functionality.

---

# Findings

| Test ID | Vulnerability                  | Severity | Endpoint    |
| ------- | ------------------------------ | -------- | ----------- |
| 009     | GraphQL Information Disclosure | High     | /graphql/v1 |

---

# Impact

An attacker could abuse GraphQL introspection and unrestricted queries to enumerate backend schema information, discover hidden objects, and retrieve sensitive application data. This could facilitate further attacks, unauthorized access, and sensitive information disclosure.

---

# Remediation

* Disable GraphQL introspection in production environments
* Restrict access to sensitive fields and hidden objects
* Implement strict authorization checks for GraphQL queries
* Limit excessive data exposure in API responses
* Sanitize verbose error messages and schema disclosures

