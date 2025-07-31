# Python user authentication service

from typing import Optional, Dict
from datetime import datetime

class User:
    def __init__(self, user_id: str, email: str, role: str, last_login: Optional[datetime] = None):
        self.id = user_id
        self.email = email
        self.role = role
        self.last_login = last_login

class AuthService:
    def __init__(self):
        self.users: Dict[str, User] = {}

    async def authenticate_user(self, email: str, password: str) -> Optional[User]:
        user = next((u for u in self.users.values() if u.email == email), None)
        
        if user and await self.verify_password(password, user.id):
            user.last_login = datetime.now()
            return user
        return None

    async def verify_password(self, password: str, user_id: str) -> bool:
        # Implementation details...
        return True
```