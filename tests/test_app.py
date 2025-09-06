from app import app


def test_home():
    client = app.test_client()
    response = client.get("/")
    assert response.status_code == 200
    assert b"My Portfolio" in response.data


def test_projects():
    client = app.test_client()
    response = client.get("/projects")
    assert response.status_code == 200
    assert b"Projects" in response.data
