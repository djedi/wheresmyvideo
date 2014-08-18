def get_display_name(user):
    if user.first_name and user.last_name:
        return '{} {}'.format(user.first_name, user.last_name)
    elif user.first_name:
        return user.first_name
    else:
        return user.username