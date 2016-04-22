base:
  '*':
    - common

  'roles:swift':
    - match: grain
    - swift

  'roles:haproxy':
    - match: grain
    - haproxy
